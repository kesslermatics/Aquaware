from django.urls import path
from . import views as water_views

urlpatterns = [
    # Add water values
    path('', water_views.add_water_values, name='add-water-values'),  # POST

    # Get water values for specific parameters
    path('parameters/<str:parameter_name>/<int:number_of_entries>/', water_views.get_all_values_from_parameter, name='get-parameter-values'),  # GET
    path('parameters/<str:parameter_name>/total/', water_views.get_total_entries, name='get-parameter-total-entries'),  # GET

    # Get latest water values
    path('latest/<int:number_of_entries>/', water_views.get_latest_from_all_parameters, name='get-latest-values'),  # GET

    # Export and import water values
    path('export/', water_views.export_water_values, name='export-water-values'),  # GET
    path('import/', water_views.import_water_values, name='import-water-values'),  # POST

    # Manage alert settings
    path('alerts/', water_views.save_alert_settings, name='save-alert-settings'),  # POST
    path('alerts/<str:parameter_name>/', water_views.get_alert_settings, name='get-alert-settings'),  # GET
]
