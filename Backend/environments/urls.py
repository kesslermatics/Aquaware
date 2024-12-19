from django.urls import path
from . import views as environment_views

urlpatterns = [
    # Create and list environments
    path('', environment_views.environment_views, name='get-environments'),  # GET and POST and DELETE and PUT

    # Retrieve, update, delete an environment by ID
    path('<int:id>/', environment_views.update_environment, name='update-environment'),  # PUT
    path('<int:id>/', environment_views.delete_environment, name='delete-environment'),  # DELETE

    # Public environments
    path('public/', environment_views.get_public_environments, name='get-public-environments'),  # GET

    # Subscription management
    path('<int:environment_id>/subscribe/', environment_views.subscribe_to_environment, name='subscribe-environment'),  # POST
]
