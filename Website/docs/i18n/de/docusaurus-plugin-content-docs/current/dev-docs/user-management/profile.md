---
sidebar_position: 5
---

# Profil

Die Aquaware-API ermöglicht es dir, Details zu deinem Benutzerprofil über den Endpunkt `/api/users/profile` abzurufen. Dieser Endpunkt liefert wichtige Benutzerdaten wie E-Mail, Name, Datum der Kontoerstellung, API-Schlüssel und Abonnementstufe.

## Abrufen deiner Profildaten

Du kannst deine Profildaten mit dem folgenden API-Endpunkt abrufen:

- **URL:** `http://dev.aquaware.cloud/api/users/profile/`
- **Methode:** `GET`
- **Autorisierung:** Erfordert ein gültiges JWT-Token im Anfrage-Header.

### Beispielanfrage

Um deine Profildetails abzurufen, füge dein JWT-Token in den `Authorization`-Header der Anfrage ein.

```bash
GET http://dev.aquaware.cloud/api/users/profile/
Authorization: Bearer <your-jwt-token>
```

### Antwort

Bei einer erfolgreichen Anfrage gibt die API die folgenden Benutzerdetails im JSON-Format zurück:

- `email`: Deine registrierte E-Mail-Adresse.
- `first_name`: Dein Vorname.
- `last_name`: Dein Nachname.
- `date_joined`: Datum und Uhrzeit der Kontoerstellung.
- `api_key`: Dein einzigartiger API-Schlüssel für den programmgesteuerten Zugriff.
- `subscription_tier`: Dein aktueller Abonnementplan (z. B. "Hobby", "Advanced", "Premium").

### Beispiel-Antwort

```json
{
  "email": "john.doe@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "date_joined": "2023-12-01T14:32:00Z",
  "api_key": "abcd1234efgh5678ijkl",
  "subscription_tier": "Hobby"
}
```

### Hinweise

- Stelle sicher, dass dein JWT-Token gültig ist; abgelaufene oder ungültige Tokens führen zu einem Authentifizierungsfehler.
- Der `api_key` ist ein sensibler Wert. Teile ihn nicht öffentlich, da er Zugriff auf dein Aquaware-Konto ermöglicht.
- Der Wert `subscription_tier` kann den Zugriff auf bestimmte Funktionen oder APIs beeinflussen.