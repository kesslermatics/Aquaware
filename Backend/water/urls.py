from django.urls import path
from .views import add_water_value, get_water_values

urlpatterns = [
    path('add/', add_water_value, name='add_water_value'),
    path('<int:aquarium_id>/values/', get_water_values, name='get_water_values'),
]
