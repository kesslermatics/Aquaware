from django.urls import path
from . import views as user_views
from django.contrib.auth import views as auth_views

urlpatterns = [
    # Authentication
    path('auth/signup/', user_views.signup, name='auth-signup'),  # POST
    path('auth/signup/google/', user_views.google_signup, name='auth-google-signup'),  # POST
    path('auth/login/', user_views.login, name='auth-login'),  # POST
    path('auth/login/google/', user_views.google_login, name='auth-google-login'),  # POST
    path('auth/token/refresh/', user_views.refresh_access_token, name='auth-token-refresh'),  # POST

    # User Profile
    path('<int:user_id>/', user_views.get_user_profile, name='user-detail'),  # GET
    path('<int:user_id>/', user_views.update_user_profile, name='user-update'),  # PUT/PATCH
    path('<int:user_id>/', user_views.delete_user_account, name='user-delete'),  # DELETE

    # Password Management
    path('auth/password/change/', user_views.change_password, name='auth-password-change'),  # POST
    path('auth/password/forgot/', user_views.forgot_password, name='auth-password-forgot'),  # POST
    path('auth/password/reset/', auth_views.PasswordResetView.as_view(), name='auth-password-reset'),  # POST
    path('auth/password/reset/done/', auth_views.PasswordResetDoneView.as_view(), name='auth-password-reset-done'),
    # GET
    path('auth/password/reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(),
         name='auth-password-reset-confirm'),  # POST
    path('auth/password/reset/complete/', auth_views.PasswordResetCompleteView.as_view(),
         name='auth-password-reset-complete'),  # GET

    # API Key Management
    path('auth/api-key/regenerate/', user_views.regenerate_api_key, name='auth-api-key-regenerate'),  # POST

    # CSRF Token
    path('auth/csrf-token/', user_views.get_csrf_token, name='auth-csrf-token'),  # GET

    # Feedback and Requests
    path('feedback/', user_views.send_feedback, name='feedback'),  # POST
    path('feedback/tailored-request/', user_views.send_tailored_request_email, name='tailored-request'),  # POST

    # Webhooks
    path('webhooks/stripe/', user_views.stripe_webhook, name='webhook-stripe'),  # POST
]
