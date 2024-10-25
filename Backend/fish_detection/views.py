import requests
import json
import time
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
import openai
from django.conf import settings
from PIL import Image
import io
import base64
from .models import FishDetection

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def identify_fish_from_image(request):
    user = request.user

    # Check if user has the correct subscription tier (e.g., Tier 3 - Premium)
    if user.subscription_tier.id != 3:
        return Response({"detail": "This feature is only available for Premium subscribers."},
                        status=status.HTTP_403_FORBIDDEN)

    # Check if an image was uploaded
    if 'image' not in request.FILES:
        return Response({"error": "No image file provided."}, status=status.HTTP_400_BAD_REQUEST)

    # Retrieve the uploaded image
    image = request.FILES['image']

    try:
        # Open the image and convert to base64
        image_data = image.read()
        base64_image = base64.b64encode(image_data).decode('utf-8')

        # Define the prompt for identifying the fish
        prompt = (
            "You will receive an image of a fish. Your task is to identify the species of the fish in the image. "
            "If there is a fish, determine what type of fish it is. "
            "Respond **only** in the following JSON format **without any additional text or formatting or explanations as clear text**:\n"            
            "{\n"
            '  "fish_detected": true or false,\n'
            '  "species": "name of the fish species",\n'
            '  "certainty": percentage of how certain you are about the fish species,\n'
            "}"
        )

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {settings.OPENAI_API_KEY_FISH_DETECTION}"
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
                                "detail": "high"
                            }
                        }
                    ]
                }
            ],
            "max_tokens": 150
        }

        # Measure the time taken for the request
        start_time = time.time()
        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        end_time = time.time()

        # Handle the response from OpenAI
        response_data = response.json()
        fish_info = response_data['choices'][0]['message']['content'].strip()
        print(fish_info)
        fish_info_cleaned = fish_info.replace('```', '').strip()
        fish_info_cleaned = fish_info_cleaned.replace('json', '').strip()

        # Parse the JSON response
        try:
            fish_info_json = json.loads(fish_info_cleaned)
        except json.JSONDecodeError as e:
            return Response({"error": "Failed to parse the response as JSON", "details": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Save the fish detection data to the database
        FishDetection.objects.create(
            fish_detected=fish_info_json['fish_detected'],
            species=fish_info_json['species'],
            confidence=fish_info_json['certainty'],
            prompt_tokens=response_data['usage']['prompt_tokens'],
            completion_tokens=response_data['usage']['completion_tokens'],
            total_tokens=response_data['usage']['total_tokens'],
            model_used=response_data['model'],
            time_taken=end_time - start_time,
            image_size=len(base64_image),
            user=user
        )

        # Return the parsed response
        return Response(fish_info_json, status=status.HTTP_200_OK)

    except Exception as e:
        # Handle errors and exceptions
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
