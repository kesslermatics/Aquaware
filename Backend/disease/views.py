import os
import requests
import json
from openai import OpenAI
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from django.conf import settings

client = OpenAI()


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def diagnosis_from_image(request):
    user = request.user

    # Check if the user has the required subscription tier
    if user.subscription_tier.id != 3:
        return Response({"detail": "This feature is only available for Premium subscribers."},
                        status=status.HTTP_403_FORBIDDEN)

    # Check if an image was uploaded
    if 'image' not in request.FILES:
        return Response({"error": "No image file provided."}, status=status.HTTP_400_BAD_REQUEST)

    try:
        image = request.FILES['image']

        # Save the image file to the media folder (or a custom path)
        path = default_storage.save(f'images/{image.name}', ContentFile(image.read()))
        print(path)
        image_url = os.path.join(settings.MEDIA_URL, path)

        # Define the prompt for diagnosing the fish disease
        prompt = (
            "You will receive an image of a fish. Your sole task is to determine the disease of the fish. "
            "If there is a fish in the image, identify whether the fish has a disease or is healthy. "
            "Respond **only** in the following JSON format **without any additional text or explanations as clear text**:\n"
            "{\n"
            '  "fish_detected": true or false,\n'
            '  "condition": "healthy" or the identified disease with their name,\n'
            '  "symptoms": "In two sentences, explain the symptoms of the identified disease",\n'
            '  "curing": "In two sentences, suggest treatments for the identified disease",\n'
            '  "certainty": percentage of how certain you are of the diagnosis\n'
            "}"
        )

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {settings.OPENAI_API_KEY_DISEASE_DETECTION}"
        }

        payload = {
            "model": "gpt-4o-mini",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": prompt},
                        {"type": "image_url", "image_url": {"url": image_url}}
                    ]
                }
            ],
            "max_tokens": 300
        }

        # Send the request to the OpenAI API
        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        print(response.json())
        diagnosis = response.json()['choices'][0]['message']['content'].strip()

        # Parse the diagnosis string as JSON
        diagnosis_json = json.loads(diagnosis)

        # Return the diagnosis as a JSON response
        return Response(diagnosis_json, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    finally:
        # Delete the uploaded image after processing
        if os.path.exists(image_url):
            os.remove(image_url)
