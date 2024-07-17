from django.urls import re_path
from . import views as user_views

urlpatterns = [
    re_path(r"signup/", user_views.signup),
    re_path(r"login/", user_views.login),
    re_path(r"profile/", user_views.get_user_profile),
    re_path(r"profile/update/", user_views.update_user_profile),
    re_path(r"change_password/", user_views.change_password),
    re_path(r"delete_account/", user_views.delete_user_account),
]
