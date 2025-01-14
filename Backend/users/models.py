from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin, Group, Permission
from django.db import models
import secrets
from django.utils import timezone

class SubscriptionTier(models.Model):
    HOBBY = 'hobby'
    ADVANCED = 'advanced'
    PREMIUM = 'premium'

    TIER_CHOICES = [
        (HOBBY, 'Hobby'),
        (ADVANCED, 'Advanced'),
        (PREMIUM, 'Premium'),
    ]

    name = models.CharField(max_length=50, choices=TIER_CHOICES, unique=True)
    price = models.DecimalField(max_digits=6, decimal_places=2)
    description = models.TextField(blank=True)
    upload_frequency_minutes = models.PositiveIntegerField()
    environment_limit = models.PositiveIntegerField(default=1)

    def __str__(self):
        return self.name


class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.api_key = secrets.token_hex(20)  # Generate API key at creation
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(auto_now_add=True)
    reset_code = models.CharField(max_length=8, blank=True, null=True)
    reset_code_expiration = models.DateTimeField(blank=True, null=True)

    # API Key for automated requests
    api_key = models.CharField(
        max_length=40,
        unique=True,
        default=secrets.token_hex(20)
    )

    groups = models.ManyToManyField(
        Group,
        related_name='custom_user_groups',
        blank=True,
        help_text='The groups this user belongs to.',
        verbose_name='groups'
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='custom_user_permissions',
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions'
    )

    objects = UserManager()

    subscription_tier = models.ForeignKey(SubscriptionTier, on_delete=models.CASCADE, null=False, blank=False,
                                          related_name='users')

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def regenerate_api_key(self):
        """Regenerate the API key for the user."""
        self.api_key = secrets.token_hex(20)
        self.save(update_fields=['api_key'])

    def clear_reset_code(self):
        """Clear the reset code after it's used or expired."""
        self.reset_code = None
        self.reset_code_expiration = None
        self.save(update_fields=['reset_code', 'reset_code_expiration'])

    def __str__(self):
        return self.email


class DeveloperAPIKey(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="developer_api_keys"
    )
    key = models.CharField(max_length=40, unique=True, default=secrets.token_hex(20))
    name = models.CharField(max_length=100, help_text="Name of the API key, e.g., 'My App'")
    description = models.TextField(blank=True, null=True, help_text="Purpose or additional information about this API key")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} - {self.key[:10]} (User: {self.user.email})"
