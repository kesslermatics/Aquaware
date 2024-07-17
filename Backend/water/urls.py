from django.urls import path
from . import views as water_views

urlpatterns = [
    path('add/', water_views.add_water_values, name='add-water-values'),
    path('aquariums/<int:aquarium_id>/water-values/<str:parameter_name>/', water_views.get_all_values_from_parameter, name='aquarium-parameter-values'),
    path('aquariums/<int:aquarium_id>/water-values/', water_views.get_all_values, name='aquarium-water-values'),
]
