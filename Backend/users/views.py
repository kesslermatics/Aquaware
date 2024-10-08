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
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import SubscriptionTier
from .serializers import UserSerializer, RegisterSerializer, CustomTokenObtainPairSerializer

from aquaware import settings

User = get_user_model()

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
                'access': access_token,
                'refresh': refresh_token,
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
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                'detail': 'Google signup successful'
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


@swagger_auto_schema(
    method='post',
    request_body=UserSerializer,
    responses={
        202: 'Login successful',
        400: 'Invalid credentials'
    }
)
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
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            "user": serializer.data
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

            user.last_login = timezone.now()
            user.save(update_fields=['last_login'])

            # Generate JWT tokens
            refresh = RefreshToken.for_user(user)
            return Response({
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                'detail': 'Google login successful'
            }, status=status.HTTP_200_OK)

        except ValueError:
            return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response({"error": f"Internal Server Error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def refresh_access_token(request):
    refresh_token = request.data.get('refresh')

    if refresh_token is None:
        return Response({'error': 'Refresh token is required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        refresh = RefreshToken(refresh_token)
        new_access_token = refresh.access_token
        return Response({'access': str(new_access_token)}, status=status.HTTP_200_OK)
    except TokenError as e:
        return Response({'error': 'Invalid refresh token'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_profile(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_user_profile(request):
    user = request.user
    serializer = UserSerializer(user, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    user = request.user
    current_password = request.data.get("current_password")
    new_password = request.data.get("new_password")

    if not user.check_password(current_password):
        return Response({"detail": "Current password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)

    user.set_password(new_password)
    user.save()
    return Response({"detail": "Password has been changed."})


@csrf_protect
def delete_account_view(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')
        user = authenticate(request, email=email, password=password)

        if user is not None and user == request.user:
            return redirect(reverse('confirm_delete_account'))
        else:
            return render(request, 'delete_account.html', {'error_message': 'Invalid email or password.'})
    return render(request, 'delete_account.html')


@api_view(['POST'])
@permission_classes([IsAuthenticated])
@csrf_protect
def confirm_delete_account(request):
    user = request.user
    user.delete()
    logout(request)
    return Response({'message': 'Your account has been deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_user_account(request):
    user = request.user

    user.delete()
    return Response({"detail": "User account has been deleted."}, status=status.HTTP_204_NO_CONTENT)


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

        token = default_token_generator.make_token(user)
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        reset_link = f"{settings.FRONTEND_URL}/reset-password/{uid}/{token}/"

        mail_subject = 'Password Reset Request'
        message = render_to_string('password_reset_email.html', {
            'user': user,
            'reset_link': reset_link,
        })

        send_mail(
            mail_subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            html_message=message)

        return Response({'detail': 'Password reset email has been sent'}, status=status.HTTP_200_OK)
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
@permission_classes([IsAuthenticated])
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
    print("Event constructed:" + event['type'])
    # Handle the event
    if event['type'] == 'customer.subscription.created':
        handle_subscription_created(event['data']['object'])

    elif event['type'] == 'customer.subscription.updated':
        handle_subscription_updated(event['data']['object'])

    elif event['type'] == 'customer.subscription.deleted':
        handle_subscription_deleted(event['data']['object'])

    return JsonResponse({'status': 'success'})

def handle_subscription_created(subscription):
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription['items']['data'][0]['price']['nickname'])

def handle_subscription_updated(subscription):
    customer_email = get_email_from_subscription(subscription)
    update_user_subscription(customer_email, subscription['items']['data'][0]['price']['nickname'])

def handle_subscription_deleted(subscription):
    customer_email = get_email_from_subscription(subscription)
    remove_user_subscription(customer_email)

def get_email_from_subscription(subscription):
    customer_id = subscription['customer']
    customer = stripe.Customer.retrieve(customer_id)
    return customer['email']

def update_user_subscription(email, subscription_name):
    print(f"Updating subscription for {email} to {subscription_name}")
    try:
        user = User.objects.get(email=email)
        subscription_tier = SubscriptionTier.objects.get(name=subscription_name)
        user.subscription_tier = subscription_tier
        user.save()
    except User.DoesNotExist:
        print(f"User with email {email} does not exist.")
    except SubscriptionTier.DoesNotExist:
        print(f"SubscriptionTier {subscription_name} does not exist.")

def remove_user_subscription(email):
    try:
        user = User.objects.get(email=email)
        # Remove the subscription by setting a default tier or null (depends on your logic)
        hobby_tier = SubscriptionTier.objects.get(name="hobby")
        user.subscription_tier = hobby_tier
        user.save()
    except User.DoesNotExist:
        print(f"User with email {email} does not exist.")
    except SubscriptionTier.DoesNotExist:
        print("Hobby subscription tier does not exist.")