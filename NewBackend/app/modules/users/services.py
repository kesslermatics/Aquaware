from sqlalchemy.orm import Session
from app.modules.users.models import User, SubscriptionTier
from app.modules.users.schemas import UserCreate
from passlib.context import CryptContext
import secrets

# Passwort-Hasher (bcrypt)
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_user(db: Session, user_data: UserCreate):
    user = User(
        email=user_data.email,
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        password=get_password_hash(user_data.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def verify_password(plain_password: str, password: str) -> bool:
    """
    Verifies a hashed password against a plaintext password.
    """
    return pwd_context.verify(plain_password, password)

def authenticate_user(db: Session, email: str, password: str):
    """
    Authenticates a user by checking email and password.
    Returns the user if credentials are valid.
    """
    user = db.query(User).filter(User.email == email).first()
    if not user or not verify_password(password, user.password):
        return None
    return user