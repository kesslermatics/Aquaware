from django.urls import path
from . import views as water_views

urlpatterns = [
    path('add/<int:aquarium_id>/', water_views.add_water_values, name='add-water-values'),
    path('aquariums/<int:aquarium_id>/water-values/<str:parameter_name>/<int:number_of_entries>/', water_views.get_all_values_from_parameter, name='aquarium-parameter-values'),
    path('aquariums/<int:aquarium_id>/water-values/<str:parameter_name>/total-entries/', water_views.get_total_entries, name='aquarium-parameter-total-entries'),
    path('aquariums/<int:aquarium_id>/water-values/<int:number_of_entries>/', water_views.get_latest_from_all_parameters, name='aquarium-water-values'),
    path('aquariums/<int:aquarium_id>/export/', water_views.export_water_values, name='export-water-values'),
    path('aquariums/<int:aquarium_id>/import/', water_views.import_water_values, name='aquarium-import-values'),
    path('aquariums/<int:aquarium_id>/save-alert-settings/', water_views.save_alert_settings, name='save-alert-settings'),
    path('aquariums/<int:aquarium_id>/get_alerts/<str:parameter_name>/', water_views.get_alert_settings, name='get-alert-settings'),
]
