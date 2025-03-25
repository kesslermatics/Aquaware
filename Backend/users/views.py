import json
from tokenize import TokenError

import stripe
from coreapi.compat import force_text
from django.http import JsonResponse
from django.utils import timezone
from google.oauth2 import id_token
from django.contrib.auth.tokens import default_token_generator
from google.auth.transport import requests
from django.core.mail import send_mail
from django.middleware.csrf import get_token, logger
from django.shortcuts import redirect, render
from django.template.loader import render_to_string
from django.urls import reverse
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes, force_str
from django.contrib.auth import get_user_model, authenticate, logout
from django.views.decorators.csrf import ensure_csrf_cookie, csrf_protect, csrf_exempt
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.conf import settings
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
import random
from datetime import timedelta
from django.utils.timezone import now
from users.models import User
from water.models import Environment
from .models import SubscriptionTier
from .serializers import UserSerializer, RegisterSerializer, CustomTokenObtainPairSerializer

from users.authentication import APIKeyAuthentication
from aquaware import settings

User = get_user_model()
stripe.api_key = settings.STRIPE_SECRET_KEY

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer


from django.contrib.auth import get_user_model

@api_view(['POST'])
def signup(request):
    try:
        User = get_user_model()
        email = request.data.get('email')

        # Check if the email already exists
        if User.objects.filter(email=email).exists():
            return Response({'detail': 'Email already in use'}, status=status.HTTP_409_CONFLICT)

        # Validate and save the user using the serializer
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Generate tokens (access and refresh tokens)
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            refresh_token = str(refresh)

            # Return a response with the tokens and a success message
            return Response({
                'detail': 'User created successfully',
                'api_key': user.api_key,
            }, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        print(f"Error in signup view: {e}")
        return Response({'detail': 'Internal Server Error'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def google_signup(request):
    try:
        token = request.data.get('token')
        if not token:
            return Response({"error": "No token provided"}, status=status.HTTP_400_BAD_REQUEST)

        # Google token verification
        try:
            idinfo = id_token.verify_oauth2_token(token, requests.Request())
            email = idinfo.get('email')
            first_name = idinfo.get('given_name', '')
            last_name = idinfo.get('family_name', '')

            User = get_user_model()
            user, created = User.objects.get_or_create(email=email, defaults={
                'first_name': first_name,
                'last_name': last_name,
                'subscription_tier': SubscriptionTier.objects.get(id=1)  # Default to free tier
            })

            if not created:
                return Response({"error": "User with this email already exists"}, status=status.HTTP_409_CONFLICT)

            # Create JWT tokens
            refresh = RefreshToken.for_user(user)
            return Response({
                'detail': 'User created successfully',
                'api_key': user.api_key,
            }, status=status.HTTP_201_CREATED)

        except ValueError:
            return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        print(f"Error during Google signup: {e}")
        return Response({"error": "Internal server error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@ensure_csrf_cookie
@api_view(['GET'])
def get_csrf_token(request):
    token = get_token(request)
    return Response({'csrfToken': token})


@api_view(['POST'])
def login(request):
    email = request.data.get('email')
    password = request.data.get('password')
    user = authenticate(request, email=email, password=password)

    if user is not None:
        refresh = RefreshToken.for_user(user)
        serializer = UserSerializer(instance=user)

        user.last_login = timezone.now()
        user.save(update_fields=['last_login'])

        return Response({
            "api_key": user.api_key,
            "user": serializer.data,
        }, status=status.HTTP_202_ACCEPTED)
    else:
        return Response({'message': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def google_login(request):
    try:
        token = request.data.get('token')
        if not token:
            return Response({"error": "No token provided"}, status=status.HTTP_400_BAD_REQUEST)

        # Verify Google token
        try:
            idinfo = id_token.verify_oauth2_token(token, requests.Request())
            email = idinfo.get('email')

            # Check if the user exists
            user = User.objects.filter(email=email).first()

            if not user:
                return Response({"error": "User not found, please sign up first"}, status=status.HTTP_404_NOT_FOUND)

            # Update last login timestamp
            user.last_login = timezone.now()
            user.save(update_fields=['last_login'])

            # Ensure the user has an API Key
            if not user.api_key:
                user.regenerate_api_key()

            return Response({
                "api_key": user.api_key,
                "detail": "Google login successful",
            }, status=status.HTTP_200_OK)

        except ValueError:
            return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response({"error": f"Internal Server Error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET', 'PUT', 'DELETE'])
@authentication_classes([APIKeyAuthentication])
def profile_views(request):
    if request.method == 'GET':
        return get_user_profile(request)
    elif request.method == 'PUT':
        return update_user_profile(request)
    elif request.method == 'DELETE':
        return delete_account(request)


def get_user_profile(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)


def update_user_profile(request):
    user = request.user
    serializer = UserSerializer(user, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def delete_account(request):
    user = request.user
    user.email = f"Deleted user {user.id}"
    user.first_name = "Deleted"
    user.last_name = "User"
    user.save()

    logout(request)
    return Response({"detail": "Your account has been deleted successfully."}, status=status.HTTP_204_NO_CONTENT)

@api_view(['POST'])
@authentication_classes([APIKeyAuthentication])
def change_password(request):
    user = request.user
    current_password = request.data.get("current_password")
    new_password = request.data.get("new_password")

    if not user.check_password(current_password):
        return Response({"detail": "Current password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)

    user.set_password(new_password)
    user.save()
    return Response({"detail": "Password has been changed."})


@api_view(['POST'])
def forgot_password(request):
    try:
        email = request.data.get('email')
        if not email:
            return Response({'error': 'Email is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User with this email does not exist'}, status=status.HTTP_404_NOT_FOUND)

        # Generiere einen zufälligen 8-stelligen Code
        reset_code = f"{random.randint(10000000, 99999999)}"

        # Optional: Speichere den Code mit Ablaufzeit (z. B. 10 Minuten) im User-Modell oder einem separaten Modell
        user.reset_code = reset_code
        user.reset_code_expiration = now() + timedelta(minutes=10)
        user.save()

        # Sende den Code per E-Mail
        mail_subject = 'Your Password Reset Code'
        message = f"Hello {user.first_name},\n\nYour password reset code is: {reset_code}\n\nThis code will expire in 10 minutes."
        send_mail(
            mail_subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email]
        )

        return Response({'detail': 'Password reset code has been sent to your email'}, status=status.HTTP_200_OK)
    except Exception as e:
        print(f"Error: {e}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def verify_reset_code(request):
    try:
        email = request.data.get('email')
        reset_code = request.data.get('reset_code')
        new_password = request.data.get('new_password')

        if not email or not reset_code or not new_password:
            return Response({'error': 'Email, reset code, and new password are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User with this email does not exist'}, status=status.HTTP_404_NOT_FOUND)

        if user.reset_code != reset_code:
            return Response({'error': 'Invalid reset code'}, status=status.HTTP_400_BAD_REQUEST)

        if user.reset_code_expiration < now():
            user.clear_reset_code()
            return Response({'error': 'Reset code has expired'}, status=status.HTTP_400_BAD_REQUEST)

        # Setze das neue Passwort
        user.set_password(new_password)
        user.save()
        user.clear_reset_code()

        return Response({'detail': 'Password has been reset successfully'}, status=status.HTTP_200_OK)
    except Exception as e:
        print(f"Error: {e}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def reset_password(request):
    try:
        uid = request.data.get('uid')
        token = request.data.get('token')
        new_password = request.data.get('new_password')

        if not uid or not token or not new_password:
            return Response({'error': 'Missing parameters'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_id = force_text(urlsafe_base64_decode(uid))
            user = User.objects.get(pk=user_id)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)

        if default_token_generator.check_token(user, token):
            user.set_password(new_password)
            user.save()
            return Response({'detail': 'Password has been reset successfully'}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@authentication_classes([APIKeyAuthentication])
def send_feedback(request):
    title = request.data.get('title')
    message = request.data.get('message')

    if not title or not message:
        return Response({'error': 'Title and message are required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        send_mail(
            f"Feedback: {title}",
            message,
            settings.DEFAULT_FROM_EMAIL,
            ['info@kesslermatics.com'],
            fail_silently=False,
        )
        return Response({'detail': 'Feedback sent successfully.'}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([AllowAny])
def send_tailored_request_email(request):
    try:
        first_name = request.data.get('firstName')
        last_name = request.data.get('lastName')
        organization = request.data.get('organization', 'Not provided')
        email = request.data.get('email')
        message = request.data.get('message')

        if not (first_name and last_name and email and message):
            return Response({"detail": "All required fields must be filled."}, status=status.HTTP_400_BAD_REQUEST)

        # Email content
        subject = f"Tailored Application Request from {first_name} {last_name}"
        full_message = f"Name: {first_name} {last_name}\n"
        full_message += f"Organization: {organization}\n"
        full_message += f"Email: {email}\n\n"
        full_message += f"Message:\n{message}"

        # Send the email
        send_mail(
            subject,
            full_message,
            settings.DEFAULT_FROM_EMAIL,
            ['info@kesslermatics.com'],
            fail_silently=False,
        )

        return Response({"detail": "Email sent successfully."}, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
def stripe_webhook(request):
    print("Stripe webhook received")
    payload = request.body
    sig_header = request.META['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = settings.STRIPE_WEBHOOK_SECRET

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    except ValueError:
        print("Invalid payload")
        return JsonResponse({'error': 'Invalid payload'}, status=400)
    except stripe.error.SignatureVerificationError:
        print("Invalid signature")
        return JsonResponse({'error': 'Invalid signature'}, status=400)
    if event['type'] == 'customer.subscription.created':
        handle_subscription_created(event['data']['object'])

    elif event['type'] == 'customer.subscription.updated':
        handle_subscription_updated(event['data']['object'])

    elif event['type'] == 'customer.subscription.deleted':
        handle_subscription_deleted(event['data']['object'])

    elif event['type'] == 'invoice.payment_failed':
        handle_payment_failed(event['data']['object'])

    return JsonResponse({'status': 'success'})

def handle_subscription_created(subscription):
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription['items']['data'][0]['plan']['product'])

def handle_subscription_updated(subscription):
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription['items']['data'][0]['plan']['product'])

def handle_subscription_deleted(subscription):
    customer_email = get_email_from_subscription(subscription)
    remove_user_subscription(customer_email)

def handle_payment_failed(invoice):
    customer_email = get_email_from_invoice(invoice)
    remove_user_subscription(customer_email)
    print(f"Payment failed for {customer_email}. Subscription downgraded.")

def get_email_from_subscription(subscription):
    customer_id = subscription['customer']
    customer = stripe.Customer.retrieve(customer_id)
    return customer['email']

def get_email_from_invoice(invoice):
    customer_id = invoice['customer']
    customer = stripe.Customer.retrieve(customer_id)
    return customer['email']

def update_user_subscription(email, product_id):
    try:
        user = User.objects.get(email=email)
        subscription_tier = "Hobby"
        if product_id == "prod_Qz0KqGeOXBrWMP":
            subscription_tier = SubscriptionTier.objects.get(id=2)
        if product_id == "prod_Qz0Lzwswmwr5X1":
            subscription_tier = SubscriptionTier.objects.get(id=3)
        user.subscription_tier = subscription_tier
        user.save()
    except User.DoesNotExist:
        print(f"User with email {email} does not exist.")
    except SubscriptionTier.DoesNotExist:
        print(f"SubscriptionTier {product_id} does not exist.")

def remove_user_subscription(email):
    try:
        user = User.objects.get(email=email)
        hobby_tier = SubscriptionTier.objects.get(id=1)
        user.subscription_tier = hobby_tier
        user.save()
    except User.DoesNotExist:
        print(f"User with email {email} does not exist.")
    except SubscriptionTier.DoesNotExist:
        print("Hobby subscription tier does not exist.")

@api_view(['POST'])
@authentication_classes([APIKeyAuthentication])
def regenerate_api_key(request):
    user = request.user
    user.regenerate_api_key()
    return Response(
        {"message": "API key successfully regenerated.", "api_key": user.api_key},
        status=status.HTTP_200_OK
    )


@api_view(['GET'])
@authentication_classes([APIKeyAuthentication])
def get_update_frequency(request):
    """Returns the user's update frequency in minutes, seconds, milliseconds, and hours."""

    user = request.user  # Get the authenticated user

    if not user.subscription_tier:
        return Response({"error": "User does not have a subscription tier"}, status=400)

    update_frequency_minutes = user.subscription_tier.upload_frequency_minutes

    response_data = {
        "minutes": update_frequency_minutes,
        "seconds": update_frequency_minutes * 60,
        "milliseconds": update_frequency_minutes * 60 * 1000,
        "hours": round(update_frequency_minutes / 60, 2)
    }

    return Response(response_data, status=200)

@csrf_exempt
@api_view(['POST'])
def mqtt_auth(request):
    """
    Authenticates the MQTT client via API key.
    """
    api_key = request.data.get("username")

    try:
        user = User.objects.get(api_key=api_key)
        return JsonResponse({"result": "allow"})
    except User.DoesNotExist:
        return JsonResponse({"result": "deny"})

@csrf_exempt
@api_view(['POST'])
def mqtt_acl(request):
    """
    Authorizes topic access for the given API key.
    Only allows access to topics for environments owned by the user.
    """
    print("📥 [ACL] Incoming ACL request")

    # Log raw request data
    print(f"📦 Raw request data: {request.data}")

    api_key = request.data.get("username")
    topic = request.data.get("topic")
    action = request.data.get("action")

    print(f"🔑 Username (API Key): {api_key}")
    print(f"📍 Topic: {topic}")
    print(f"🛠️ Action: {action}")

    if not api_key or not topic:
        print("❌ Missing username or topic in request")
        return JsonResponse({"result": "deny"})

    try:
        user = User.objects.get(api_key=api_key)
        print(f"✅ Found user: {user.email}")
    except User.DoesNotExist:
        print("❌ No user found with this API key")
        return JsonResponse({"result": "deny"})

    # Check if topic is valid
    if not topic.startswith("env/"):
        print("❌ Topic does not start with 'env/' – access denied")
        return JsonResponse({"result": "deny"})

    try:
        env_id = int(topic.split("/")[1])
        print(f"🔍 Extracted Environment ID from topic: {env_id}")
    except IndexError:
        print("❌ Failed to extract environment ID from topic")
        return JsonResponse({"result": "deny"})

    if Environment.objects.filter(id=env_id, user=user).exists():
        print(f"✅ User owns environment {env_id} – access allowed")
        return JsonResponse({"result": "allow"})
    else:
        print(f"❌ User does NOT own environment {env_id} – access denied")
        return JsonResponse({"result": "deny"})
