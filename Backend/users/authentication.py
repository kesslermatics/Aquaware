from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from water.models import User
from users.models import DeveloperAPIKey  # Importiere das DeveloperAPIKey-Modell


class APIKeyAuthentication(BaseAuthentication):
    def authenticate(self, request):
        # Hole den API Key aus den Headern
        api_key = request.headers.get("X-API-KEY")
        if not api_key:
            return None

        # Prüfe den API Key gegen die User-Tabelle (Hochladen von Wasserwerten)
        try:
            user = User.objects.get(api_key=api_key, is_active=True)
            return (user, None)
        except User.DoesNotExist:
            pass  # Falls kein passender User gefunden wird, prüfe die Developer API Keys

        # Prüfe den API Key gegen die DeveloperAPIKey-Tabelle
        try:
            developer_api_key = DeveloperAPIKey.objects.get(key=api_key)
            return (developer_api_key.user, None)  # Rückgabe des Nutzers, der mit dem Key verknüpft ist
        except DeveloperAPIKey.DoesNotExist:
            raise AuthenticationFailed("Invalid API key.")
