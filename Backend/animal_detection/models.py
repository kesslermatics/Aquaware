from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class AnimalDetection(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)  # The user who made the request
    animal_detected = models.BooleanField()  # Whether a fish was detected in the image
    species = models.CharField(max_length=255)  # The identified fish species

    # Additional fish information
    habitat = models.CharField(max_length=255, blank=True, null=True)  # Typical habitat of the fish species
    diet = models.CharField(max_length=255, blank=True, null=True)  # Dietary habits of the fish species
    average_size = models.CharField(max_length=50, blank=True, null=True)  # Average size of the species
    behavior = models.TextField(blank=True, null=True)  # Common behaviors of the fish
    lifespan = models.CharField(max_length=50, blank=True, null=True)  # Average lifespan of the fish species
    visual_characteristics = models.TextField(blank=True, null=True)  # Distinct visual features

    # Meta information about the OpenAI response
    prompt_tokens = models.IntegerField()  # Number of tokens used in the prompt
    completion_tokens = models.IntegerField()  # Number of tokens used in the completion
    total_tokens = models.IntegerField()  # Total number of tokens used
    model_used = models.CharField(max_length=255)  # The model used for this request (e.g., 'gpt-4')
    time_taken = models.FloatField()  # Time taken for the API to process the request
    image_size = models.IntegerField()  # Size of the base64 image (in bytes)

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)  # When the detection request was made

    def __str__(self):
        return f"Fish Detection ({self.species}) by {self.user.username} - Confidence: {self.confidence}%"
