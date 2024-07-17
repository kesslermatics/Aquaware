from django.urls import path
from views import create_aquarium, get_aquarium, update_aquarium, delete_aquarium

urlpatterns = [
    path('create/', create_aquarium, name='create_aquarium'),
    path('<int:id>/', get_aquarium, name='get_aquarium'),
    path('<int:id>/update/', update_aquarium, name='update_aquarium'),
    path('<int:id>/delete/', delete_aquarium, name='delete_aquarium'),
]
