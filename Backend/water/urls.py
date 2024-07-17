from django.urls import re_path
from . import views as water_views

urlpatterns = [
    re_path(r"add/", water_views.add_water_values),
    re_path(r"(?P<aquarium_id>\d+)/values/(?P<parameter_name>[\w-]+)/$", water_views.get_aquarium_parameter_values),
    re_path(r"(?P<aquarium_id>\d+)/values/", water_views.get_water_values),

]
