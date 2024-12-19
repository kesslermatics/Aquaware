from django.urls import path
from . import views as environment_views

urlpatterns = [
    # Create and list environments
    path('', environment_views.environment_views, name='get-environments'),

    # Retrieve, update, delete an environment by ID
    path('<int:id>/', environment_views.environment_id_views, name='update-environment'),

    # Public environments
    path('public/', environment_views.get_public_environments, name='get-public-environments'),  # GET

    # Subscription management
    path('<int:environment_id>/subscribe/', environment_views.subscribe_to_environment, name='subscribe-environment'),  # POST
]
