---
sidebar_position: 1
---

# Konto erstellen

Die Erstellung eines Kontos bei Aquaware ist einfach und in wenigen Schritten erledigt. Du kannst dich entweder direkt über unsere Website oder auch über die App registrieren.

## So erstellst du ein Konto

Um ein Konto zu erstellen, gehe zur [Aquaware-Registrierungsseite](https://dashboard.aquaware.cloud/signup). Alternativ kannst du ein Konto programmgesteuert erstellen, indem du eine Anfrage an unsere API sendest.

### Registrierung per API

Du kannst den folgenden API-Endpunkt verwenden, um ein Konto zu erstellen:

- **URL:** `https://dev.aquaware.cloud/api/users/auth/signup/`
- **Methode:** `POST`
- **Content-Type:** `application/json`

### Beispielanfrage

Hier ist ein Beispiel für eine Anfrage zur Kontoerstellung über die API:

```bash
POST https://dev.aquaware.cloud/api/users/auth/signup/
Content-Type: application/json
```

### Anfrage-Body

Der Anfrage-Body sollte die folgenden Felder im JSON-Format enthalten:

```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "password": "SuperSecurePassword123!",
  "password2": "SuperSecurePassword123!"
}
```

### Anforderungen an das Passwort

Das Passwort muss bestimmte Kriterien erfüllen, um die Sicherheit zu gewährleisten. Wir verwenden die **Django-Passwortvalidierung**, um folgende Regeln durchzusetzen:

- **Mindestlänge:** Das Passwort muss mindestens 8 Zeichen lang sein.
- **Komplexität:** Es muss eine Mischung aus Groß- und Kleinbuchstaben, mindestens eine Ziffer und mindestens ein Sonderzeichen (z. B. `@`, `!`, `#`, `$`) enthalten.
- **Validierung:** Die Felder `password` und `password2` müssen übereinstimmen, um sicherzustellen, dass du dein Passwort korrekt bestätigt hast.

Wenn das Passwort diese Anforderungen nicht erfüllt, gibt die API einen Fehler mit Details zurück, was behoben werden muss.

### Antwort

Eine erfolgreiche Kontoerstellung gibt den Statuscode `201 Created` zurück und eine Antwort wie diese:

```json
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "date_joined": "2024-09-20T12:00:00Z"
}
```

## Passwortsicherheit

Bei Aquaware nehmen wir die Passwortsicherheit sehr ernst, um deine Daten zu schützen. So behandeln wir Passwörter:

### Wie Passwörter gespeichert werden

1. **Passwort-Hashing**: Wir speichern Passwörter nicht im Klartext. Stattdessen werden sie mit einem starken, einseitigen kryptografischen Hashing-Algorithmus gehasht.
2. **Salted Hashing**: Jedes Passwort wird mit einem einzigartigen Salt kombiniert, um zusätzliche Sicherheit gegen vorberechnete Angriffe (z. B. Rainbow-Table-Angriffe) zu bieten.
3. **Django-Passwortvalidierung**: Passwörter werden mit den integrierten Sicherheitsfunktionen von Django validiert und gespeichert, um den besten Praktiken in der Passwortspeicherung und -verschlüsselung zu entsprechen.

### Sicherheitsmerkmale

- **Starker Hashing-Algorithmus**: Wir verwenden sichere Hashing-Algorithmen wie PBKDF2, bcrypt oder Argon2, um sicherzustellen, dass selbst bei einem Datenleck Passwörter nicht einfach zurückverfolgt werden können.
- **Passwortvalidierung**: Passwörter werden serverseitig validiert, um Sicherheitsanforderungen zu erfüllen (z. B. Mindestlänge, Komplexität), und das Risiko schwacher Passwörter zu reduzieren.

Durch die Verwendung von Industriestandards in Verschlüsselung und Sicherheitstechniken sorgen wir dafür, dass dein Konto und deine Daten geschützt sind.

---

Wenn du Probleme hast oder Hilfe benötigst, kontaktiere gerne unser Support-Team.
