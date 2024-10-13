from django.contrib.auth import get_user_model
from django.db import models
from django.contrib.auth.models import User

User = get_user_model()

class DiseaseDetection(models.Model):
    # Basic diagnostic information
    fish_detected = models.BooleanField()
    condition = models.CharField(max_length=255)
    symptoms = models.TextField()
    curing = models.TextField()
    certainty = models.DecimalField(max_digits=5, decimal_places=2)  # store as percentage

    # OpenAI API usage information
    prompt_tokens = models.IntegerField()
    completion_tokens = models.IntegerField()
    total_tokens = models.IntegerField()
    model_used = models.CharField(max_length=255)
    time_taken = models.FloatField()  # Time in seconds
    base64_image_size = models.CharField(max_length=50)  # Store image size as string (e.g. '1024x1024')

    # Additional metadata
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Detection {self.id} - {self.condition} (User: {self.user})"
