from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models


class User(AbstractUser):
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

    groups = models.ManyToManyField(
        Group,
        related_name='custom_user_set',  # Ändere den related_name, um Konflikte zu vermeiden
        blank=True,
        help_text='The groups this user belongs to.',
        verbose_name='groups'
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='custom_user_set',  # Ändere den related_name, um Konflikte zu vermeiden
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions'
    )

