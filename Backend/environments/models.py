from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Environment(models.Model):

    ENVIRONMENT_TYPES = [
        ('aquarium', 'Aquarium'),
        ('lake', 'Lake'),
        ('sea', 'Sea'),
        ('pool', 'Pool'),
        ('other', 'Other'),
    ]

    user = models.ForeignKey(User, on_delete=models.SET_NULL, blank=True, null=True, related_name='environments')
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    environment_type = models.CharField(max_length=50, choices=ENVIRONMENT_TYPES)
    created_at = models.DateTimeField(auto_now_add=True)
    public = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'name')  # Ensure unique aquarium names per user

    def __str__(self):
        return f"{self.name} ({self.environment_type})"
