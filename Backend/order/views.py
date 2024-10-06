import json
from django.conf import settings
from django.http import JsonResponse
import stripe

stripe.api_key = settings.STRIPE_SECRET_KEY


def create_checkout_session(request):
    if request.method == 'POST':
        data = json.loads(request.body)

        try:
            # Create a new Stripe Checkout session
            session = stripe.checkout.Session.create(
                payment_method_types=['card'],
                line_items=[{
                    'price': data['price_id'],  # Die Price ID aus Stripe
                    'quantity': 1,
                }],
                mode='subscription',
                success_url='https://your-domain/success/',
                cancel_url='https://your-domain/cancel/',
            )
            return JsonResponse({'id': session.id})
        except Exception as e:
            return JsonResponse({'error': str(e)})