from django.db import models
from django.contrib.auth.models import User

User = get_user_model()

class FishDetection(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)  # The user who made the request
    fish_detected = models.BooleanField()  # Whether a fish was detected in the image
    species = models.CharField(max_length=255)  # The identified fish species
    confidence = models.DecimalField(max_digits=5, decimal_places=2)  # Confidence percentage of the identification

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
