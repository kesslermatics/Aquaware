from django.urls import re_path
from . import views as aquarium_views

urlpatterns = [
    re_path("create/", aquarium_views.create_aquarium),
    re_path(r"(?P<id>\d+)/", aquarium_views.get_aquarium),
    re_path(r"(?P<id>\d+)/update/", aquarium_views.update_aquarium),
    re_path(r"(?P<id>\d+)/delete/", aquarium_views.delete_aquarium),
]
