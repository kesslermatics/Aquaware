import secrets
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, DECIMAL
from sqlalchemy.orm import relationship
from app.core.database import Base

class SubscriptionTier(Base):
    __tablename__ = "subscription_tiers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    price = Column(DECIMAL(6, 2), nullable=False)
    description = Column(String, nullable=True)
    upload_frequency_minutes = Column(Integer, nullable=False)
    environment_limit = Column(Integer, default=1)

    users = relationship("User", back_populates="subscription_tier")

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False, index=True)
    first_name = Column(String(30), nullable=True)
    last_name = Column(String(30), nullable=True)
    password = Column(String, nullable=False)
    date_joined = Column(DateTime, default=datetime.now(timezone.utc))

    api_key = Column(String(40), unique=True, default=lambda: secrets.token_hex(20))

    reset_code = Column(String(8), nullable=True)
    reset_code_expiration = Column(DateTime, nullable=True)

    subscription_tier_id = Column(Integer, ForeignKey("subscription_tiers.id"), nullable=False, default=1)
    subscription_tier = relationship("SubscriptionTier", back_populates="users")

    def regenerate_api_key(self):
        """Regenerate the API key for the user."""
        self.api_key = secrets.token_hex(20)

    def clear_reset_code(self):
        """Clear the reset code after it's used or expired."""
        self.reset_code = None
        self.reset_code_expiration = None
