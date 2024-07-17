import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aquaware.settings')
django.setup()

from water.models import WaterParameter

parameters = [
    {'name': 'pH', 'unit': 'pH'},
    {'name': 'temperature', 'unit': '°C'},
    {'name': 'tds', 'unit': 'ppm'},
    {'name': 'oxygen', 'unit': 'mg/L'}
]

for param in parameters:
    WaterParameter.objects.get_or_create(name=param['name'], defaults={'unit': param['unit']})

print("Water parameters initialized.")