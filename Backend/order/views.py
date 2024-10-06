import paypalrestsdk
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings
from urllib.parse import urlparse, parse_qs

from order.models import Invoice
from users.models import SubscriptionTier

paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,  # sandbox oder live
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_order(request):

    try:
        plan = request.data.get("plan")
        amount = request.data.get("amount")

        if not plan or not amount:
            return Response({"detail": "Plan and amount are required."}, status=status.HTTP_400_BAD_REQUEST)

        payment = paypalrestsdk.Payment({
            "intent": "sale",
            "payer": {
                "payment_method": "paypal"
            },
            "transactions": [{
                "item_list": {
                    "items": [{
                        "price": str(amount),
                        "currency": "EUR",
                        "quantity": 1
                    }]
                },
                "amount": {
                    "total": str(amount),
                    "currency": "EUR"
                },
                "description": f"Subscription plan {plan} purchase"
            }],
            "redirect_urls": {
                "return_url": "https://aquaware.cloud/payment/success",
                "cancel_url": "https://aquaware.cloud/payment/cancel"
            }
        })

        if payment.create():
            token = ''
            for link in payment.links:
                if link.rel == "approval_url":
                    url = link.href
                    parsed_url = urlparse(url)
                    query_params = parse_qs(parsed_url.query)
                    token = query_params.get('token', [None])[0]
            return Response({"id": token}, status=status.HTTP_201_CREATED)
        else:
            return Response({"error": payment.error}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def capture_order(request, order_id):
    try:
        # Log to see the initial incoming request data
        print(f"Starting capture for order_id: {order_id}")
        print(f"Request data: {request.data}")

        # Attempt to find the payment via PayPal SDK
        payment = paypalrestsdk.Payment.find(order_id)
        print(f"Payment found: {payment}")

        # Attempt to execute the payment
        if payment.execute({"payer_id": order_id}):
            print("Payment executed successfully")

            user = request.user
            subscription_tier_name = request.data.get('plan')
            print(f"Subscription tier name from request: {subscription_tier_name}")

            # Get the subscription tier from the database
            subscription_tier = SubscriptionTier.objects.get(name=subscription_tier_name)
            print(f"Subscription tier object found: {subscription_tier}")

            # Update user's subscription tier
            user.subscription_tier = subscription_tier
            user.save()
            print(f"User's subscription updated to: {subscription_tier}")

            # Create an invoice for the payment
            amount_paid = payment.transactions[0].amount.total
            print(f"Amount paid: {amount_paid}")

            invoice = Invoice.objects.create(
                user=user,
                amount=amount_paid,
                description=f"Subscription plan {subscription_tier.name} purchase",
                status="paid",
                subscription_tier=subscription_tier,
                invoice_id=payment.id
            )
            print(f"Invoice created: {invoice}")

            # Return a successful response
            return Response({"status": "Payment captured successfully."}, status=status.HTTP_200_OK)
        else:
            # Print the error if payment execution fails
            print(f"Payment execution failed with error: {payment.error}")
            return Response({"error": payment.error}, status=status.HTTP_400_BAD_REQUEST)

    except SubscriptionTier.DoesNotExist:
        # Handle case where the subscription tier is invalid
        print(f"SubscriptionTier not found: {request.data.get('plan')}")
        return Response({"error": "Invalid subscription tier."}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        # Log any unexpected exception that occurs
        print(f"An unexpected error occurred: {str(e)}")
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
            "subscription_tier": invoice.subscription_tier.name,  # Zugriff auf das SubscriptionTier
            "invoice_id": invoice.invoice_id,
        }
        for invoice in invoices
    ]
    return Response(invoice_data, status=status.HTTP_200_OK)