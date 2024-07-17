from django.urls import re_path
from .views import create_aquarium, get_aquarium, update_aquarium, delete_aquarium

urlpatterns = [
    re_path(r'^create/$', create_aquarium, name='create_aquarium'),
    re_path(r'^(?P<id>\d+)/$', get_aquarium, name='get_aquarium'),
    re_path(r'^(?P<id>\d+)/update/$', update_aquarium, name='update_aquarium'),
    re_path(r'^(?P<id>\d+)/delete/$', delete_aquarium, name='delete_aquarium'),
]
