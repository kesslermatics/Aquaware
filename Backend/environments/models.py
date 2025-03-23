from django.db import models
from django.contrib.auth import get_user_model
from django.conf import settings
from django.utils import timezone

User = get_user_model()

class Environment(models.Model):

    ENVIRONMENT_TYPES = [
        ('aquarium', 'Aquarium'),
        ('pond', 'Pond'),
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
    city = models.CharField(max_length=255, blank=True, null=True)

    is_setup = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'name')

    def __str__(self):
        return f"{self.name} ({self.environment_type})"


# Model to store the relationship between users and their subscriptions to public environments
class UserEnvironmentSubscription(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='subscriptions')
    environment = models.ForeignKey(Environment, on_delete=models.SET_NULL, null=True, related_name='subscribed_users')
    subscribed_at = models.DateTimeField(default=timezone.now)

    class Meta:
        unique_together = ('user', 'environment')

    def __str__(self):
        return f"{self.user.username} subscribed to {self.environment.name}"