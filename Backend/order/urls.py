from django.urls import path
from . import views as user_views, views
from django.contrib.auth import views as auth_views

from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('', views.create_order, name='create_order'),
    path('<order_id>/capture/', views.capture_order, name='capture_order'),
    path('get-invoices/', views.get_user_invoices, name='capture_order'),
]
