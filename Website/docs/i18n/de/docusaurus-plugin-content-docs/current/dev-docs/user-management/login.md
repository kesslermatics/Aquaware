---
sidebar_position: 2
---

# Anmeldung

Um auf dein Aquaware-Konto zuzugreifen, kannst du dich entweder über unsere Website, die App oder programmatisch über unsere API anmelden. Nach der Anmeldung erhältst du JWT-Tokens, die **für zukünftige Autorisierungen entscheidend** sind.

## Anmeldung über die API

Du kannst dich mit dem folgenden API-Endpunkt anmelden:

- **URL:** `http://dev.aquaware.cloud/api/users/auth/login/`
- **Methode:** `POST`
- **Content-Type:** `multipart/form-data`

### Beispielanfrage

Du musst deine E-Mail und dein Passwort im Anfrage-Body angeben, um dich anzumelden.

```bash
POST http://dev.aquaware.cloud/api/users/auth/login/
Content-Type: multipart/form-data
```

### Anfrage-Body

Der Anfrage-Body sollte die folgenden Felder enthalten:

- `email`: Deine registrierte E-Mail-Adresse
- `password`: Dein Kontopasswort

### Beispiel-Anfrage-Body

```json
{
  "email": "john.doe@example.com",
  "password": "SuperSecurePassword123!"
}
```

### Antwort

Nach einer erfolgreichen Anmeldung erhältst du deine JWT-Tokens, die für zukünftige Autorisierungen verwendet werden.

### Profilverwaltung

Nach der Anmeldung kannst du dein Profil auf der [Aquaware-Profilverwaltungsseite](https://dashboard.aquaware.cloud) verwalten.

Weitere Informationen darüber, wie JWT-Tokens funktionieren und für die Autorisierung verwendet werden, findest du [hier](./jwt-tokens).

---

Wenn du Probleme hast oder Hilfe benötigst, schau in unsere [Dokumentation](#) oder kontaktiere unser Support-Team.
