from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed

from water.models import User


class APIKeyAuthentication(BaseAuthentication):
    def authenticate(self, request):
        api_key = request.headers.get("X-API-KEY")
        if not api_key:
            return None

        try:
            user = User.objects.get(api_key=api_key, is_active=True)
            return (user, None)
        except User.DoesNotExist:
            raise AuthenticationFailed("Invalid or inactive API key.")
