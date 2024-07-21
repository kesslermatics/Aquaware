from django.urls import path
from . import views as user_views
from django.contrib.auth import views as auth_views


urlpatterns = [
    path('signup/', user_views.signup, name='user-signup'),
    path('login/', user_views.login, name='user-login'),
    path('token/refresh/', user_views.refresh_access_token, name='user-login'),
    path('get-csrf-token/', user_views.get_csrf_token, name='get-csrf-token'),
    path('profile/', user_views.get_user_profile, name='user-profile'),
    path('profile/update/', user_views.update_user_profile, name='update-user-profile'),
    path('change-password/', user_views.change_password, name='change-password'),
    path('delete-account/', user_views.delete_user_account, name='delete-user-account'),
    path('forgot-password/', user_views.forgot_password, name='forgot-password'),
    path('reset-password/', auth_views.PasswordResetView.as_view(), name='password_reset'),
    path('reset-password/done/', auth_views.PasswordResetDoneView.as_view(), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('reset/done/', auth_views.PasswordResetCompleteView.as_view(), name='password_reset_complete'),
]
