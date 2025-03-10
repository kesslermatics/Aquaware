"""
Django settings for aquaware project.

Generated by 'django-admin startproject' using Django 4.2.13.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""
import os
from datetime import timedelta
from pathlib import Path

from django.conf.global_settings import DATABASES, DEBUG
from dotenv import load_dotenv
from corsheaders.defaults import default_headers

import dj_database_url

SWAGGER_SETTINGS = {
   'USE_SESSION_AUTH': False
}

DATA_UPLOAD_MAX_MEMORY_SIZE = 10485760

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.getenv("SECRET_KEY")

SECURE_SSL_REDIRECT = False

CSRF_TRUSTED_ORIGINS = [
    'https://dev.aquaware.cloud',
]

ALLOWED_HOSTS = ['aquaware-production.up.railway.app', 'localhost', '127.0.0.1', 'dev.aquaware.cloud']

AUTH_USER_MODEL = 'users.User'

AUTHENTICATION_BACKENDS = (
    'users.backends.EmailBackend',
    'django.contrib.auth.backends.ModelBackend',
)

STRIPE_PUBLIC_KEY = os.environ.get('STRIPE_PUBLIC_KEY')
STRIPE_SECRET_KEY = os.environ.get('STRIPE_SECRET_KEY')
STRIPE_WEBHOOK_SECRET = os.environ.get('STRIPE_WEBHOOK_SECRET')

OPENAI_API_KEY_DISEASE_DETECTION = os.environ.get('OPENAI_API_KEY_DISEASE_DETECTION')
OPENAI_API_KEY_FISH_DETECTION = os.environ.get('OPENAI_API_KEY_FISH_DETECTION')

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = os.environ.get('EMAIL_PORT')
EMAIL_USE_TLS = os.environ.get('EMAIL_USE_TLS')
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')
DEFAULT_FROM_EMAIL = os.environ.get('DEFAULT_FROM_EMAIL')

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            os.path.join(BASE_DIR, 'templates'),
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

FRONTEND_URL = 'https://aquaware.cloud'

INSTALLED_APPS = [
    'django.contrib.admin',
    'django_extensions',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    "django.contrib.staticfiles",
    'rest_framework',
    'rest_framework_swagger',
    #'rest_framework.authtoken',
    'rest_framework_simplejwt',
    'drf_yasg',
    "debug_toolbar",
    "aquaware",
    "users",
    "environments",
    "water",
    "logs",
    'corsheaders',
    "disease",
    "animal_detection"
]

STATIC_URL = "/static/"

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'request_logging.middleware.LoggingMiddleware',
    'middleware.logging_middleware.APILoggingMiddleware',
]

CORS_ALLOW_CREDENTIALS = True

CORS_ALLOW_ALL_ORIGINS = True

CORS_ALLOW_HEADERS = list(default_headers) + [
    'x-api-key',
]

ROOT_URLCONF = 'aquaware.urls'

WSGI_APPLICATION = 'aquaware.wsgi.application'

DATABASES["default"] = dj_database_url.parse(os.environ.get("DATABASE_URL"))

STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
}

INTERNAL_IPS = [
    "127.0.0.1",
]

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]
