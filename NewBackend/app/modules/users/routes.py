import random
from fastapi import APIRouter, Depends, HTTPException, Header, Security
from sqlalchemy.orm import Session
from google.auth.transport import requests
from google.oauth2 import id_token
from datetime import datetime, timedelta, timezone
from app.core.database import get_db
from app.modules.users.models import User, SubscriptionTier
from app.modules.users.schemas import UserCreate, UserResponse, UserUpdate
from app.modules.users.services import authenticate_user, create_user, get_password_hash, get_user_by_email, verify_password
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel, EmailStr
from app.core.auth import get_current_user
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from app.core.config import settings
import stripe
from app.core.email import fm

router = APIRouter()

class GoogleTokenRequest(BaseModel):
    token: str


stripe.api_key = settings.STRIPE_SECRET_KEY


@router.post("/api/users/auth/signup", response_model=dict, status_code=201)
def signup(user_data: UserCreate, db: Session = Depends(get_db)):
    """
    Registers a new user. Returns an API key if successful.
    """
    existing_user = get_user_by_email(db, user_data.email)
    if existing_user:
        raise HTTPException(status_code=409, detail="Email already in use")

    user = create_user(db, user_data)
    return {
        "detail": "User created successfully",
        "api_key": user.api_key
    }

@router.post("/api/users/auth/signup/google/", response_model=dict, status_code=201)
def google_signup(request: GoogleTokenRequest, db: Session = Depends(get_db)):
    """
    Registers a new user using Google OAuth2. 
    Returns an API key if successful.
    """
    if not request.token:
        raise HTTPException(status_code=400, detail="No token provided")

    try:
        idinfo = id_token.verify_oauth2_token(request.token, requests.Request())
        email = idinfo.get("email")
        first_name = idinfo.get("given_name", "")
        last_name = idinfo.get("family_name", "")

        # Check if user exists
        existing_user = db.query(User).filter(User.email == email).first()
        if existing_user:
            raise HTTPException(status_code=409, detail="User with this email already exists")

        # Create a new user with a default subscription tier
        user = User(
            email=email,
            first_name=first_name,
            last_name=last_name,
            subscription_tier_id=1  # Default to free tier
        )
        db.add(user)
        db.commit()
        db.refresh(user)

        return {
            "detail": "User created successfully",
            "api_key": user.api_key
        }

    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid token")

@router.post("/api/users/auth/login/", response_model=dict)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    """
    Logs in a user with email and password authentication.
    Returns an API key if successful.
    """
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Invalid credentials")

    # Update last login timestamp
    user.last_login = datetime.now(timezone.utc)
    db.commit()

    return {
        "api_key": user.api_key,
        "user": {
            "id": user.id,
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
        }
    }

@router.post("/api/users/auth/login/google/", response_model=dict)
def google_login(request: GoogleTokenRequest, db: Session = Depends(get_db)):
    """
    Logs in a user using Google OAuth2.
    Returns an API key if successful.
    """
    if not request.token:
        raise HTTPException(status_code=400, detail="No token provided")

    try:
        idinfo = id_token.verify_oauth2_token(request.token, requests.Request())
        email = idinfo.get("email")

        user = db.query(User).filter(User.email == email).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found, please sign up first")

        # Update last login timestamp
        user.last_login = datetime.now(timezone.utc)
        db.commit()

        # Ensure user has an API key
        if not user.api_key:
            user.regenerate_api_key()
            db.commit()

        return {
            "api_key": user.api_key,
            "detail": "Google login successful"
        }

    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid token")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@router.get("/api/users/profile", response_model=UserResponse)
def get_user_profile(current_user: User = Depends(get_current_user)):
    """
    Retrieves the authenticated user's profile.
    Requires a valid API key in the 'X-API-KEY' header.
    """
    return current_user

@router.put("/api/users/profile", response_model=UserResponse)
def update_user_profile(
    user_update: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Updates the authenticated user's profile.
    Partial updates are allowed.
    """
    for field, value in user_update.dict(exclude_unset=True).items():
        setattr(current_user, field, value)

    db.commit()
    db.refresh(current_user)
    return current_user

@router.delete("/api/users/profile", status_code=204)
def delete_account(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Deletes the authenticated user's account.
    The email is anonymized, and the user's name is set to 'Deleted User'.
    """
    current_user.email = f"Deleted user {current_user.id}"
    current_user.first_name = "Deleted"
    current_user.last_name = "User"

    db.commit()
    return {"detail": "Your account has been deleted successfully."}

class ChangePasswordRequest(BaseModel):
    current_password: str
    new_password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class VerifyResetCodeRequest(BaseModel):
    email: EmailStr
    reset_code: str
    new_password: str

class ResetPasswordRequest(BaseModel):
    uid: str
    token: str
    new_password: str

@router.post("/api/users/auth/password/change", response_model=dict)
def change_password(
    request: ChangePasswordRequest, 
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Allows an authenticated user to change their password.
    Requires current password and new password.
    """
    if not verify_password(request.current_password, current_user.password):
        raise HTTPException(status_code=400, detail="Current password is incorrect.")

    current_user.password = get_password_hash(request.new_password)
    db.commit()

    return {"detail": "Password has been changed."}

@router.post("/api/users/auth/password/forgot", response_model=dict)
def forgot_password(request: ForgotPasswordRequest, db: Session = Depends(get_db)):
    """
    Sends a password reset code to the user's email if the email exists in the system.
    """
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User with this email does not exist.")

    # Generate a random 8-digit reset code
    reset_code = f"{random.randint(10000000, 99999999)}"
    user.reset_code = reset_code
    user.reset_code_expiration = datetime.now(timezone.utc) + timedelta(minutes=10)
    db.commit()

    # Send email (FastMail configuration required)
    message = MessageSchema(
        subject="Your Password Reset Code",
        recipients=[user.email],
        body=f"Hello {user.first_name},\n\nYour password reset code is: {reset_code}\n\nThis code will expire in 10 minutes.",
        subtype="plain"
    )

    try:
        fm = FastMail(ConnectionConfig(
            MAIL_USERNAME=settings.EMAIL_HOST_USER,
            MAIL_PASSWORD=settings.EMAIL_HOST_PASSWORD,
            MAIL_FROM=settings.EMAIL_HOST_USER,
            MAIL_PORT=settings.EMAIL_PORT,
            MAIL_SERVER=settings.EMAIL_HOST,
            MAIL_FROM_NAME="Aquaware Support",
            MAIL_TLS=settings.EMAIL_USE_TLS,
            MAIL_SSL=not settings.EMAIL_USE_TLS
        ))
        fm.send_message(message)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error sending email: {str(e)}")

    return {"detail": "Password reset code has been sent to your email."}

@router.post("/api/users/auth/password/reset", response_model=dict)
def verify_reset_code(request: VerifyResetCodeRequest, db: Session = Depends(get_db)):
    """
    Verifies the password reset code and allows the user to set a new password.
    """
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User with this email does not exist.")

    if user.reset_code != request.reset_code:
        raise HTTPException(status_code=400, detail="Invalid reset code.")

    if user.reset_code_expiration < datetime.now(timezone.utc):
        user.reset_code = None
        user.reset_code_expiration = None
        db.commit()
        raise HTTPException(status_code=400, detail="Reset code has expired.")

    # Set new password and clear reset code
    user.password = get_password_hash(request.new_password)
    user.reset_code = None
    user.reset_code_expiration = None
    db.commit()

    return {"detail": "Password has been reset successfully."}

class FeedbackRequest(BaseModel):
    title: str
    message: str

@router.post("/api/users/feedback/", response_model=dict)
def send_feedback(
    request: FeedbackRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    Sends user feedback via email.
    Requires a valid API key in 'X-API-KEY' header.
    """
    try:
        message = MessageSchema(
            subject=f"Feedback: {request.title}",
            recipients=["info@kesslermatics.com"],
            body=request.message,
            subtype="plain"
        )
        fm.send_message(message)
        return {"detail": "Feedback sent successfully."}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error sending email: {str(e)}")

class TailoredRequest(BaseModel):
    first_name: str
    last_name: str
    organization: str = "Not provided"
    email: EmailStr
    message: str

@router.post("/api/users/feedback/tailored-request/", response_model=dict)
def send_tailored_request_email(request: TailoredRequest):
    """
    Sends a tailored application request via email.
    """
    try:
        email_content = f"""
        Name: {request.first_name} {request.last_name}
        Organization: {request.organization}
        Email: {request.email}

        Message:
        {request.message}
        """

        message = MessageSchema(
            subject=f"Tailored Application Request from {request.first_name} {request.last_name}",
            recipients=["info@kesslermatics.com"],
            body=email_content,
            subtype="plain"
        )
        fm.send_message(message)

        return {"detail": "Email sent successfully."}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error sending email: {str(e)}")
    
@router.post("/api/users/webhooks/stripe/")
async def stripe_webhook(request: dict, stripe_signature: str = Header(None), db: Session = Depends(get_db)):
    """
    Handles Stripe webhook events for subscription management.
    """
    print("Stripe webhook received")

    endpoint_secret = settings.STRIPE_WEBHOOK_SECRET
    try:
        event = stripe.Webhook.construct_event(
            payload=request, sig_header=stripe_signature, secret=endpoint_secret
        )
    except ValueError:
        print("Invalid payload")
        raise HTTPException(status_code=400, detail="Invalid payload")
    except stripe.error.SignatureVerificationError:
        print("Invalid signature")
        raise HTTPException(status_code=400, detail="Invalid signature")

    event_type = event.get("type")

    if event_type == "customer.subscription.created":
        handle_subscription_created(event["data"]["object"], db)
    elif event_type == "customer.subscription.updated":
        handle_subscription_updated(event["data"]["object"], db)
    elif event_type == "customer.subscription.deleted":
        handle_subscription_deleted(event["data"]["object"], db)
    elif event_type == "invoice.payment_failed":
        handle_payment_failed(event["data"]["object"], db)

    return {"status": "success"}

def handle_subscription_created(subscription: dict, db: Session):
    """
    Handles new subscriptions by updating the user's subscription tier.
    """
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription["items"]["data"][0]["plan"]["product"], db)

def handle_subscription_updated(subscription: dict, db: Session):
    """
    Updates an existing subscription with new details.
    """
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription["items"]["data"][0]["plan"]["product"], db)

def handle_subscription_deleted(subscription: dict, db: Session):
    """
    Downgrades the user's subscription when it is deleted.
    """
    customer_email = get_email_from_subscription(subscription)
    remove_user_subscription(customer_email, db)

def handle_payment_failed(invoice: dict, db: Session):
    """
    Downgrades the user if a payment fails.
    """
    customer_email = get_email_from_invoice(invoice)
    remove_user_subscription(customer_email, db)
    print(f"Payment failed for {customer_email}. Subscription downgraded.")

def get_email_from_subscription(subscription: dict) -> str:
    """
    Retrieves the email of a customer from a Stripe subscription.
    """
    customer_id = subscription["customer"]
    customer = stripe.Customer.retrieve(customer_id)
    return customer["email"]

def get_email_from_invoice(invoice: dict) -> str:
    """
    Retrieves the email of a customer from a Stripe invoice.
    """
    customer_id = invoice["customer"]
    customer = stripe.Customer.retrieve(customer_id)
    return customer["email"]

def update_user_subscription(email: str, product_id: str, db: Session):
    """
    Updates a user's subscription tier based on the Stripe product ID.
    """
    try:
        user = db.query(User).filter(User.email == email).first()
        if not user:
            print(f"User with email {email} does not exist.")
            return

        # Default to Hobby Tier
        subscription_tier = db.query(SubscriptionTier).filter(SubscriptionTier.id == 1).first()

        if product_id == "prod_Qz0KqGeOXBrWMP":
            subscription_tier = db.query(SubscriptionTier).filter(SubscriptionTier.id == 2).first()
        elif product_id == "prod_Qz0Lzwswmwr5X1":
            subscription_tier = db.query(SubscriptionTier).filter(SubscriptionTier.id == 3).first()

        if not subscription_tier:
            print(f"SubscriptionTier {product_id} does not exist.")
            return

        user.subscription_tier = subscription_tier
        db.commit()

    except Exception as e:
        print(f"Error updating subscription for {email}: {str(e)}")

def remove_user_subscription(email: str, db: Session):
    """
    Downgrades a user's subscription to the Hobby tier.
    """
    try:
        user = db.query(User).filter(User.email == email).first()
        if not user:
            print(f"User with email {email} does not exist.")
            return

        hobby_tier = db.query(SubscriptionTier).filter(SubscriptionTier.id == 1).first()
        if not hobby_tier:
            print("Hobby subscription tier does not exist.")
            return

        user.subscription_tier = hobby_tier
        db.commit()

    except Exception as e:
        print(f"Error downgrading subscription for {email}: {str(e)}")