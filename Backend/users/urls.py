from django.urls import path
from . import views as user_views

urlpatterns = [
    path('signup/', user_views.signup, name='user-signup'),
    path('login/', user_views.login, name='user-login'),
    path('token/refresh/', user_views.refresh_access_token, name='user-login'),
    path('get-csrf-token/', user_views.get_csrf_token, name='get-csrf-token'),
    path('profile/', user_views.get_user_profile, name='user-profile'),
    path('profile/update/', user_views.update_user_profile, name='update-user-profile'),
    path('change-password/', user_views.change_password, name='change-password'),
    path('delete-account/', user_views.delete_user_account, name='delete-user-account'),
]
