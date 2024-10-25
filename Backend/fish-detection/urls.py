from django.urls import path
from . import views as fish_detection_views

urlpatterns = [
    path('identify_fish_from_image/', fish_detection_views.identify_fish_from_image, name='identify_fish_from_image'),
]
