from django.contrib.auth.models import User
from django.db import models


class WaterParameter(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='water_parameters')
    timestamp = models.DateTimeField(auto_now_add=True)
    ph = models.FloatField()
    temperature = models.FloatField()
    co2 = models.FloatField()

    class Meta:
        unique_together = ('user', 'timestamp')
        indexes = [
            models.Index(fields=['user', 'timestamp']),
        ]

    def __str__(self):
        return f"{self.user.username} - {self.timestamp}"