from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from app.core.config import settings

# Configure FastMail with existing settings
conf = ConnectionConfig(
    MAIL_USERNAME=settings.EMAIL_HOST_USER,
    MAIL_PASSWORD=settings.EMAIL_HOST_PASSWORD,
    MAIL_FROM=settings.DEFAULT_FROM_EMAIL,
    MAIL_PORT=settings.EMAIL_PORT,
    MAIL_SERVER=settings.EMAIL_HOST,
    MAIL_STARTTLS=settings.EMAIL_USE_TLS,  # Use TLS if enabled
    MAIL_SSL_TLS=not settings.EMAIL_USE_TLS,  # Use SSL if TLS is disabled
    MAIL_FROM_NAME="Aquaware Support"
)

fm = FastMail(conf)
