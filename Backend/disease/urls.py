from django.urls import path
from . import views as disease_views

urlpatterns = [
    path('diagnosis/', disease_views.diagnosis_from_image, name='diagnosis_from_image'),
]
