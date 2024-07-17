from django.urls import path

from Backend.users.views import signup, login, get_user_profile, change_password, update_user_profile, \
    delete_user_account

urlpatterns = [
    path('signup/', signup, name='signup'),
    path('login/', login, name='login'),
    path('profile/', get_user_profile, name='get_user_profile'),
    path('profile/update/', update_user_profile, name='update_user_profile'),
    path('change_password/', change_password, name='change_password'),
    path('delete_account/', delete_user_account, name='delete_user_account'),
]
