import requests
import json
import time
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
import openai
from django.conf import settings
from users.models import SubscriptionTier
from PIL import Image
import io
import base64
from .models import DiseaseDetection


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

    # Retrieve the uploaded image
    image = request.FILES['image']

    try:
        # Open and convert to base64 for the API call
        image_data = image.read()
        base64_image = base64.b64encode(image_data).decode('utf-8')

        # Define the prompt for diagnosing the fish disease
        prompt = (
            "You will receive an image of a fish. Your task is to carefully and thoroughly determine whether the fish has any disease. "
            "Only provide a diagnosis if you are highly certain of the condition. In case of doubt, carefully review every detail before making a judgment. "
            "If there is any uncertainty, increase your attention to the smallest visual cues of disease. "
            "Respond **only** in the following JSON format **without any additional text or formatting or explanations as clear text**:\n"
            "{\n"
            '  "fish_detected": true or false,\n'
            '  "condition": "healthy" or the identified disease with their name,\n'
            '  "symptoms": "In two sentences, explain the symptoms of the identified disease",\n'
            '  "curing": "In two sentences, suggest treatments for the identified disease",\n'
            '  "certainty": percentage of how certain you are of the diagnosis, with 100% reserved for clear and obvious cases.\n'
            "}"
        )

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {settings.OPENAI_API_KEY_DISEASE_DETECTION}"
        }

        payload = {
            "model": "gpt-4o",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": f"{prompt}"
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}",
                                "detail": "low"
                            }
                        }
                    ]
                }
            ],
            "max_tokens": 300
        }

        # Measure time taken for API request
        start_time = time.time()
        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        end_time = time.time()

        # Extract the diagnosis from the response
        diagnosis = response.json()['choices'][0]['message']['content'].strip()

        # Extract the diagnosis from the response and clean the JSON
        diagnosis_cleaned = diagnosis.replace('```', '').strip()
        diagnosis_cleaned = diagnosis_cleaned.replace('json', '').strip()
        diagnosis_json = json.loads(diagnosis_cleaned)

        # Save the disease detection results to the database
        detection = DiseaseDetection.objects.create(
            fish_detected=diagnosis_json['fish_detected'],
            condition=diagnosis_json['condition'],
            symptoms=diagnosis_json['symptoms'],
            curing=diagnosis_json['curing'],
            certainty=diagnosis_json['certainty'],
            prompt_tokens=response.json()['usage']['prompt_tokens'],
            completion_tokens=response.json()['usage']['completion_tokens'],
            total_tokens=response.json()['usage']['total_tokens'],
            model_used=response.json()['model'],
            time_taken=end_time - start_time,
            base64_image_size=len(base64_image),
            user=user
        )

        return Response(diagnosis_json, status=status.HTTP_200_OK)

    except json.JSONDecodeError as e:
        return Response({"error": "Failed to parse the response as JSON", "details": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    except Exception as e:
        # Handle any errors that occur during processing
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)