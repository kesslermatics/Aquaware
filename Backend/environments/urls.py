from django.urls import path
from . import views as environment_views

urlpatterns = [
    path('create/', environment_views.create_environment, name='create-environments'),
    path('<int:id>/update/', environment_views.update_environment, name='update-environments'),
    path('<int:id>/delete/', environment_views.delete_environment, name='delete-environments'),
    path("", environment_views.get_user_environments, name='get-user-environments'),
    path('public/', environment_views.get_public_environments, name="get-public-environments"),

    path('<int:environment_id>/subscribe/', environment_views.subscribe_to_environment, name='subscribe-environment'),
    path('<int:environment_id>/environments/', environment_views.get_user_environments, name='unsubscribe-environment'),
]