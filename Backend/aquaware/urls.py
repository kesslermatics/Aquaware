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
from django.contrib import admin
from django.urls import re_path, include
from .views import user_views, entries_views
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView


urlpatterns = [
    re_path("admin/", admin.site.urls),
    re_path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    re_path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    re_path("user/login/", user_views.login),
    re_path("user/signup/", user_views.signup),
    re_path("user/profile/", user_views.get_user_profile),
    re_path("user/profile/update/", user_views.update_user_profile),
    re_path("user/change_password/", user_views.change_password),
    re_path("user/delete_account/", user_views.delete_user_account),
    re_path("entries/add_entry/", entries_views.add_entry),
    re_path("entries/get_all_entries/", entries_views.get_all_entries),
    re_path("__debug__/", include("debug_toolbar.urls")),
]