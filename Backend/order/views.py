import requests
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings

from order.models import Invoice
from users.models import SubscriptionTier

def get_paypal_access_token():
    url = f"https://api-m.{settings.PAYPAL_MODE}.paypal.com/v1/oauth2/token"
    headers = {
        "Accept": "application/json",
        "Accept-Language": "en_US"
    }
    data = {
        "grant_type": "client_credentials"
    }
    response = requests.post(url, headers=headers, data=data, auth=(settings.PAYPAL_CLIENT_ID, settings.PAYPAL_CLIENT_SECRET))
    if response.status_code == 200:
        return response.json()['access_token']
    else:
        return None

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_subscription(request):
    try:
        plan_id = request.data.get("plan_id")

        if not plan_id:
            return Response({"detail": "Plan ID is required."}, status=status.HTTP_400_BAD_REQUEST)

        access_token = get_paypal_access_token()
        if not access_token:
            return Response({"detail": "Failed to get PayPal access token."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        url = f"https://api-m.{settings.PAYPAL_MODE}.paypal.com/v1/billing/subscriptions"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {access_token}"
        }

        subscription_data = {
            "plan_id": plan_id,
            "subscriber": {
                "name": {
                    "given_name": request.user.first_name,
                    "surname": request.user.last_name
                },
                "email_address": request.user.email
            },
            "application_context": {
                "brand_name": "Aquaware",
                "locale": "en-US",
                "shipping_preference": "NO_SHIPPING",
                "user_action": "SUBSCRIBE_NOW",
                "return_url": "https://yourdomain.com/payment/success",
                "cancel_url": "https://yourdomain.com/payment/cancel"
            }
        }

        response = requests.post(url, headers=headers, json=subscription_data)
        if response.status_code in [201, 200]:
            response_data = response.json()
            approval_url = ""
            for link in response_data.get('links', []):
                if link.get('rel') == 'approve':
                    approval_url = link.get('href')
                    break
            return Response({"approval_url": approval_url}, status=status.HTTP_201_CREATED)
        else:
            return Response({"error": response.json()}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def capture_subscription(request):
    try:
        subscription_id = request.query_params.get('subscription_id')
        if not subscription_id:
            return Response({"detail": "Subscription ID is required."}, status=status.HTTP_400_BAD_REQUEST)

        access_token = get_paypal_access_token()
        if not access_token:
            return Response({"detail": "Failed to get PayPal access token."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Get the subscription details
        url = f"https://api-m.{settings.PAYPAL_MODE}.paypal.com/v1/billing/subscriptions/{subscription_id}"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {access_token}"
        }

        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            subscription_details = response.json()

            # Update user's subscription tier
            user = request.user
            plan_id = subscription_details['plan_id']
            subscription_tier = SubscriptionTier.objects.get(plan_id=plan_id)

            user.subscription_tier = subscription_tier
            user.save()

            # Create an invoice for the subscription
            amount_paid = subscription_details['billing_info']['last_payment']['amount']['value']
            invoice = Invoice.objects.create(
                user=user,
                amount=amount_paid,
                description=f"Subscription plan {subscription_tier.name} purchase",
                status="active",
                subscription_tier=subscription_tier,
                invoice_id=subscription_id
            )

            return Response({"status": "Subscription activated successfully."}, status=status.HTTP_200_OK)
        else:
            return Response({"error": response.json()}, status=status.HTTP_400_BAD_REQUEST)
    except SubscriptionTier.DoesNotExist:
        return Response({"error": "Invalid subscription tier."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_invoices(request):
    invoices = Invoice.objects.filter(user=request.user).order_by('-created_at')
    invoice_data = [
        {
            "id": invoice.id,
            "amount": str(invoice.amount),
            "description": invoice.description,
            "status": invoice.status,
            "created_at": invoice.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            "subscription_tier": invoice.subscription_tier.name,
            "invoice_id": invoice.invoice_id,
        }
        for invoice in invoices
    ]
    return Response(invoice_data, status=status.HTTP_200_OK)
