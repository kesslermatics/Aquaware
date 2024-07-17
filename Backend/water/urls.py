from django.urls import re_path
from .views import add_water_value, get_water_values

urlpatterns = [
    re_path(r'^add/$', add_water_value, name='add_water_value'),
    re_path(r'^(?P<aquarium_id>\d+)/values/$', get_water_values, name='get_water_values'),
]
