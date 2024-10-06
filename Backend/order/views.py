import paypalrestsdk
from django.conf import settings
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from users.models import SubscriptionTier, User
from order.models import Invoice
from datetime import datetime, timedelta

paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,  # "sandbox" oder "live"
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_billing_plan(request):
    try:
        plan_id = request.data.get("plan_id")
        subscription_tier = SubscriptionTier.objects.get(id=plan_id)

        # Create PayPal Billing Plan
        billing_plan = paypalrestsdk.BillingPlan({
            "name": f"{subscription_tier.name} Subscription Plan",
            "description": f"Monthly {subscription_tier.name} plan for {subscription_tier.price} EUR",
            "type": "fixed",
            "payment_definitions": [{
                "name": "Monthly Payments",
                "type": "REGULAR",
                "frequency": "Month",
                "frequency_interval": "1",
                "amount": {
                    "currency": "EUR",
                    "value": str(subscription_tier.price)
                },
            }],
            "merchant_preferences": {
                "auto_bill_amount": "YES",
                "cancel_url": "https://yourapp.com/payment/cancel",
                "return_url": "https://yourapp.com/payment/success",
                "initial_fail_amount_action": "CONTINUE",
            }
        })

        if billing_plan.create():
            # Activate the billing plan
            if billing_plan.activate():
                return Response({
                    "message": "Billing Plan created and activated",
                    "plan_id": billing_plan.id
                }, status=status.HTTP_201_CREATED)
            else:
                return Response({"error": billing_plan.error}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": billing_plan.error}, status=status.HTTP_400_BAD_REQUEST)
    except SubscriptionTier.DoesNotExist:
        return Response({"error": "Invalid subscription tier."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_subscription(request):
    try:
        plan_id = request.data.get("plan_id")
        subscription_tier = SubscriptionTier.objects.get(id=plan_id)

        # Create PayPal Billing Agreement (Subscription)
        billing_agreement = paypalrestsdk.BillingAgreement({
            "name": "Subscription Agreement",
            "description": f"Agreement for {subscription_tier.name} subscription",
            "start_date": (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "plan": {
                "id": subscription_tier.paypal_plan_id
            },
            "payer": {
                "payment_method": "paypal"
            }
        })

        if billing_agreement.create():
            for link in billing_agreement.links:
                if link.rel == "approval_url":
                    return Response({"approval_url": link.href}, status=status.HTTP_201_CREATED)
        else:
            return Response({"error": billing_agreement.error}, status=status.HTTP_400_BAD_REQUEST)
    except SubscriptionTier.DoesNotExist:
        return Response({"error": "Invalid subscription tier."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def execute_subscription(request):
    try:
        token = request.data.get('token')

        agreement = paypalrestsdk.BillingAgreement.execute(token)
        if agreement.state == "Active":
            user = request.user
            plan_id = request.data.get('plan_id')
            subscription_tier = SubscriptionTier.objects.get(id=plan_id)

            # Update user's subscription tier
            user.subscription_tier = subscription_tier
            user.save()

            # Create an invoice for the subscription
            invoice = Invoice.objects.create(
                user=user,
                amount=subscription_tier.price,
                description=f"Subscription plan {subscription_tier.name} activated",
                status="paid",
                subscription_tier=subscription_tier,
                invoice_id=agreement.id
            )

            return Response({"message": "Subscription activated and invoice created."}, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Subscription activation failed."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
