from django.urls import path
from . import views as user_views, views
from django.contrib.auth import views as auth_views

from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('create-subscription/', views.create_subscription, name='capture_order'),
    path('execute-subscription/', views.execute_subscription, name='capture_order'),
]
