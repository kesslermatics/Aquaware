import requests
import json
import time
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
import openai
from django.conf import settings
from PIL import Image
import io
import base64
from .models import AnimalDetection
from users.authentication import APIKeyAuthentication

@api_view(['POST'])
@authentication_classes([APIKeyAuthentication])
def identify_animal_from_image(request):
    user = request.user

    # Check if user has the correct subscription tier (e.g., Tier 3 - Premium)
    if user.subscription_tier.id == 1:
        return Response({"detail": "This feature is only available for Premium subscribers."},
                        status=status.HTTP_403_FORBIDDEN)

    # Check if an image was uploaded
    if 'image' not in request.FILES:
        return Response({"error": "No image file provided."}, status=status.HTTP_400_BAD_REQUEST)

    # Retrieve the language parameter
    language = request.data.get('language', 'en')
    if not language:
        return Response({"error": "Language parameter is required."}, status=status.HTTP_400_BAD_REQUEST)

    # Retrieve the uploaded image
    image = request.FILES['image']

    try:
        # Open the image and convert to base64
        image_data = image.read()
        base64_image = base64.b64encode(image_data).decode('utf-8')

        # Define the prompt for identifying the aquatic animal with extended information
        prompt = (
            f"You will receive an image of an aquatic animal. Your task is to identify the species of the fish in the image. "
            f"If there is an aquatic animal, determine what exact type it is. "
            f"Respond **only** in the specified language '{language}' for the values and exclusively in the following JSON format **without any additional text or formatting or explanations as clear text** and start with uppercase in these JSON values:\n"            
            f"{{\n"
            f'  "animal_detected": true or false,\n'
            f'  "species": "name of the species",\n'
            f'  "habitat": "typical habitat of the fish species",\n'
            f'  "diet": "dietary habits of the fish species",\n'
            f'  "average_size": "average size of the species in cm in the following format (minSize-maxSize cm)",\n'
            f'  "behavior": "common behaviors of the fish",\n'
            f'  "lifespan": "average lifespan of the fish species in the following format (min-max time)",\n'
            f'  "visual_characteristics": "distinct visual features like color patterns, fins, or body shape"\n'
            f"}}"
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
            "max_tokens": 300  # Increased to accommodate the additional details
        }

        # Measure the time taken for the request
        start_time = time.time()
        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        end_time = time.time()

        # Handle the response from OpenAI
        response_data = response.json()
        animal_info = response_data['choices'][0]['message']['content'].strip()
        animal_info_cleaned = animal_info.replace('```', '').strip()
        animal_info_cleaned = animal_info_cleaned.replace('json', '').strip()

        # Parse the JSON response
        try:
            animal_info_json = json.loads(animal_info_cleaned)
        except json.JSONDecodeError as e:
            return Response({"error": "Failed to parse the response as JSON", "details": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Save the fish detection data to the database
        AnimalDetection.objects.create(
            animal_detected=animal_info_json['animal_detected'],
            species=animal_info_json['species'],
            habitat=animal_info_json['habitat'],
            diet=animal_info_json['diet'],
            average_size=animal_info_json['average_size'],
            behavior=animal_info_json['behavior'],
            lifespan=animal_info_json['lifespan'],
            visual_characteristics=animal_info_json['visual_characteristics'],
            prompt_tokens=response_data['usage']['prompt_tokens'],
            completion_tokens=response_data['usage']['completion_tokens'],
            total_tokens=response_data['usage']['total_tokens'],
            model_used=response_data['model'],
            time_taken=end_time - start_time,
            image_size=len(base64_image),
            user=user
        )

        # Return the parsed response
        return Response(animal_info_json, status=status.HTTP_200_OK)

    except Exception as e:
        # Handle errors and exceptions
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
