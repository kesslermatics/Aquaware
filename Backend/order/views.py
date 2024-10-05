import paypalrestsdk
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings

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
            return Response({"id": payment.id}, status=status.HTTP_201_CREATED)
        else:
            return Response({"error": payment.error}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def capture_order(request, order_id):
    try:
        payment = paypalrestsdk.Payment.find(order_id)

        if payment.execute({"payer_id": request.data.get("payer_id")}):
            user = request.user
            subscription_tier_name = request.data.get('plan')

            subscription_tier = SubscriptionTier.objects.get(name=subscription_tier_name)

            user.subscription_tier = subscription_tier
            user.save()

            Invoice.objects.create(
                user=user,
                amount=payment.transactions[0].amount.total,
                description=f"Subscription plan {subscription_tier.name} purchase",
                status="paid",
                subscription_tier=subscription_tier,
                invoice_id=payment.id
            )

            return Response({"status": "Payment captured successfully."}, status=status.HTTP_200_OK)
        else:
            return Response({"error": payment.error}, status=status.HTTP_400_BAD_REQUEST)

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
            "subscription_tier": invoice.subscription_tier.name,  # Zugriff auf das SubscriptionTier
            "invoice_id": invoice.invoice_id,
        }
        for invoice in invoices
    ]
    return Response(invoice_data, status=status.HTTP_200_OK)