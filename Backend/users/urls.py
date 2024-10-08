from django.urls import path
from . import views as user_views
from django.contrib.auth import views as auth_views

from django.contrib import admin
from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from rest_framework import permissions

schema_view = get_schema_view(
   openapi.Info(
      title="Snippets API",
      default_version='v1',
      description="Test description",
      terms_of_service="https://www.google.com/policies/terms/",
      contact=openapi.Contact(email="contact@snippets.local"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    path('signup/', user_views.signup, name='user-signup'),
    path('google-signup/', user_views.google_signup, name='user-signup'),
    path('login/', user_views.login, name='user-login'),
    path('google-login/', user_views.google_login, name='user-login'),
    path('token/refresh/', user_views.refresh_access_token, name='user-login'),
    path('get-csrf-token/', user_views.get_csrf_token, name='get-csrf-token'),
    path('profile/', user_views.get_user_profile, name='user-profile'),
    path('profile/update/', user_views.update_user_profile, name='update-user-profile'),
    path('change-password/', user_views.change_password, name='change-password'),
    path('reset-password/', user_views.reset_password, name='reset-password'),
    path('delete-account-from-web/', user_views.delete_account_view, name='delete-user-account'),
    path('delete-account/', user_views.delete_user_account, name='delete-user-account'),
    path('confirm-delete-account/', user_views.confirm_delete_account, name='confirm_delete_account'),
    path('forgot-password/', user_views.forgot_password, name='forgot-password'),
    path('reset-password/', auth_views.PasswordResetView.as_view(), name='password_reset'),
    path('reset-password/done/', auth_views.PasswordResetDoneView.as_view(), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('reset/done/', auth_views.PasswordResetCompleteView.as_view(), name='password_reset_complete'),
    path('feedback/', user_views.send_feedback, name='send-feedback'),

    path('stripe-webhook/', user_views.stripe_webhook, name='send-feedback'),
]
