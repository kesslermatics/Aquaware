from django.urls import path
from . import views as user_views, views
from django.contrib.auth import views as auth_views

from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('create-subscription/', views.create_subscription, name='create_subscription'),
    path('capture-subscription/', views.capture_subscription, name='capture_subscription'),
    path('invoices/', views.get_user_invoices, name='get_user_invoices'),
]
