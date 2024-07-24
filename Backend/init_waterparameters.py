import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aquaware.settings')
django.setup()

from water.models import WaterParameter

parameters = [
    {'name': 'PH', 'unit': 'pH'},
    {'name': 'Temperature', 'unit': '°C'},
    {'name': 'TDS', 'unit': 'ppm'},
    {'name': 'Oxygen', 'unit': 'mg/L'},
    {'name': 'Ammonia', 'unit': 'ppm'},
    {'name': 'Nitrite', 'unit': 'ppm'},
    {'name': 'Nitrate', 'unit': 'ppm'},
    {'name': 'Phosphate', 'unit': 'ppm'},
    {'name': 'Carbon Dioxide', 'unit': 'mg/L'},
    {'name': 'Salinity', 'unit': 'ppt'},
    {'name': 'General Hardness', 'unit': 'dGH'},
    {'name': 'Carbonate Hardness', 'unit': 'dKH'},
    {'name': 'Copper', 'unit': 'ppm'},
    {'name': 'Iron', 'unit': 'ppm'},
    {'name': 'Calcium', 'unit': 'ppm'},
    {'name': 'Magnesium', 'unit': 'ppm'},
    {'name': 'Potassium', 'unit': 'ppm'},
    {'name': 'Chlorine', 'unit': 'ppm'},
    {'name': 'Alkalinity', 'unit': 'ppm'},
    {'name': 'Redox Potential', 'unit': 'mV'},
    {'name': 'Silica', 'unit': 'ppm'},
    {'name': 'Boron', 'unit': 'ppm'},
    {'name': 'Strontium', 'unit': 'ppm'},
    {'name': 'Iodine', 'unit': 'ppm'},
    {'name': 'Molybdenum', 'unit': 'ppm'},
    {'name': 'Sulfate', 'unit': 'ppm'},
    {'name': 'Organic Carbon', 'unit': 'ppm'},
    {'name': 'Turbidity', 'unit': 'NTU'},
    {'name': 'Conductivity', 'unit': 'µS/cm'},
    {'name': 'Total Organic Carbon', 'unit': 'ppm'},
    {'name': 'Suspended Solids', 'unit': 'mg/L'},
    {'name': 'Fluoride', 'unit': 'ppm'},
    {'name': 'Bromine', 'unit': 'ppm'},
    {'name': 'Chloride', 'unit': 'ppm'}
]

for param in parameters:
    WaterParameter.objects.get_or_create(name=param['name'], defaults={'unit': param['unit']})

print("Water parameters initialized.")