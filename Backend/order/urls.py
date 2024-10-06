from django.urls import path
from . import views as user_views, views
from django.contrib.auth import views as auth_views

from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('create-checkout-session/', views.create_checkout_session(), name='capture_order'),
]
