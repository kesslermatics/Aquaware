from django.urls import path
from . import views as fish_detection_views

urlpatterns = [
    path('identify-animal-from-image/', fish_detection_views.identify_animal_from_image, name='identify_animal_from_image'),
]