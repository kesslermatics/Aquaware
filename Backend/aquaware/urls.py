"""
URL configuration for aquaware project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.urls import re_path, include
from .views import user_views, entries_views

urlpatterns = [
    re_path("user/login", user_views.login),
    re_path("user/signup", user_views.signup),
    re_path("user/test", user_views.test),
    re_path("entries/add_entry", entries_views.add_entry),
    re_path("entries/get_all_entries", entries_views.get_all_entries),
    re_path("__debug__/", include("debug_toolbar.urls")),
]
