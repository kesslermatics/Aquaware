import os
from pathlib import Path
from dotenv import load_dotenv
from pydantic import Field, ConfigDict
from pydantic_settings import BaseSettings, SettingsConfigDict

# Prüfe, ob eine `.env`-Datei existiert
env_file_path = Path(".env")

if env_file_path.exists():
    load_dotenv(env_file_path)  # Lade die .env-Variablen

class Settings(BaseSettings):
    # Core settings
    SECRET_KEY: str = Field(default="default-secret-key", validation_alias="SECRET_KEY")
    DEBUG: bool = Field(default=False, validation_alias="DEBUG")
    DATABASE_URL: str = Field(default="sqlite:///./dev.db", validation_alias="DATABASE_URL")

    # Stripe API Keys
    STRIPE_PUBLIC_KEY: str = Field(default="", validation_alias="STRIPE_PUBLIC_KEY")
    STRIPE_SECRET_KEY: str = Field(default="", validation_alias="STRIPE_SECRET_KEY")
    STRIPE_WEBHOOK_SECRET: str = Field(default="", validation_alias="STRIPE_WEBHOOK_SECRET")

    # Email settings
    EMAIL_BACKEND: str = Field(default="smtp", validation_alias="EMAIL_BACKEND")
    EMAIL_HOST: str = Field(default="", validation_alias="EMAIL_HOST")
    EMAIL_PORT: int = Field(default=587, validation_alias="EMAIL_PORT")
    EMAIL_USE_TLS: bool = Field(default=True, validation_alias="EMAIL_USE_TLS")
    EMAIL_HOST_USER: str = Field(default="", validation_alias="EMAIL_HOST_USER")
    EMAIL_HOST_PASSWORD: str = Field(default="", validation_alias="EMAIL_HOST_PASSWORD")
    DEFAULT_FROM_EMAIL: str = Field(default="", validation_alias="DEFAULT_FROM_EMAIL")

    # CORS settings
    ALLOWED_HOSTS: list[str] = ['localhost', '127.0.0.1', 'dev.aquaware.cloud']
    CORS_ALLOW_ALL_ORIGINS: bool = Field(default=True, validation_alias="CORS_ALLOW_ALL_ORIGINS")
    CORS_ALLOW_HEADERS: list[str] = Field(default=["x-api-key", "Authorization"], validation_alias="CORS_ALLOW_HEADERS")

    # Frontend URL
    FRONTEND_URL: str = Field(default="http://localhost:3000", validation_alias="FRONTEND_URL")

    model_config = ConfigDict(env_file=".env", env_file_encoding="utf-8")

# Erstelle eine Settings-Instanz
settings = Settings()
