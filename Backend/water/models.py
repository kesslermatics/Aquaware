from django.db import models
from aquariums.models import Aquarium
from django.utils import timezone


class WaterParameter(models.Model):
    name = models.CharField(max_length=255, unique=True)
    unit = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class WaterValue(models.Model):
    aquarium = models.ForeignKey(Aquarium, on_delete=models.CASCADE, related_name='water_values')
    parameter = models.ForeignKey(WaterParameter, on_delete=models.CASCADE, related_name='water_values')
    value = models.DecimalField(max_digits=10, decimal_places=3)
    measured_at = models.DateTimeField(auto_now_add=True)
    generated = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.aquarium.name} - {self.parameter.name}: {self.value} {self.parameter.unit}"
