from django.contrib.auth import get_user_model
from django.db import models
from environments.models import Environment
from django.utils import timezone

User = get_user_model()

class WaterParameter(models.Model):
    name = models.CharField(max_length=255, unique=True)
    unit = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class WaterValue(models.Model):
    environment = models.ForeignKey(Environment, on_delete=models.SET_NULL, blank=True, null=True, related_name='water_values')
    parameter = models.ForeignKey(WaterParameter, on_delete=models.CASCADE, related_name='water_values')
    value = models.DecimalField(max_digits=10, decimal_places=3)
    measured_at = models.DateTimeField()
    added_at = models.DateTimeField(auto_now_add=True)
    generated = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.environment.name} - {self.parameter.name}: {self.value} {self.parameter.unit}"


class UserAlertSetting(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    environment = models.ForeignKey(Environment, on_delete=models.CASCADE)
    parameter = models.ForeignKey(WaterParameter, on_delete=models.CASCADE)
    under_value = models.FloatField(null=True, blank=True)
    above_value = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'environment', 'parameter')
