from django.urls import re_path

from .views import signup, login, get_user_profile, change_password, update_user_profile, delete_user_account

urlpatterns = [
    re_path(r'^signup/$', signup, name='signup'),
    re_path(r'^login/$', login, name='login'),
    re_path(r'^profile/$', get_user_profile, name='get_user_profile'),
    re_path(r'^profile/update/$', update_user_profile, name='update_user_profile'),
    re_path(r'^change_password/$', change_password, name='change_password'),
    re_path(r'^delete_account/$', delete_user_account, name='delete_user_account'),
]
