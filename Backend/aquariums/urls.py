from django.urls import path
from . import views as aquarium_views

urlpatterns = [
    path('create/', aquarium_views.create_aquarium, name='create-aquarium'),
    path('<int:id>/update/', aquarium_views.update_aquarium, name='update-aquarium'),
    path('<int:id>/delete/', aquarium_views.delete_aquarium, name='delete-aquarium'),
    path("", aquarium_views.get_user_aquariums),
]
