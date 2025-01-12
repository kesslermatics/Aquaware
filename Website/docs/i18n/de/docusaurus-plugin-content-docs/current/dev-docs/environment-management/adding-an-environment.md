---
sidebar_position: 1
---

# Eine Umgebung hinzufügen

Das Hinzufügen einer Umgebung in Aquaware ist ganz einfach und kann entweder über die Aquaware-App oder die API erfolgen.

## Umgebung über die App hinzufügen

Du kannst ganz bequem eine Umgebung über unsere mobile App erstellen, indem du den Bereich **„Umgebung hinzufügen“** aufrufst. Damit kannst du dein Aquarium, deinen Teich oder andere Wasserumgebungen direkt von deinem Gerät aus einrichten.

## Umgebung über die API hinzufügen

Wenn du eine Umgebung lieber programmatisch erstellen möchtest, kannst du unseren API-Endpunkt nutzen:

- **URL:** `https://dev.aquaware.cloud/api/environments/`
- **Methode:** `POST`
- **Content-Type:** `application/json`
- **Authentifizierung:** Du musst dein JWT **Access Token** in die Header der Anfrage einfügen. Mehr Infos zu [JWT Tokens findest du hier](../user-management/jwt-tokens).

### Erforderliche Felder

Beim Erstellen einer Umgebung musst du die folgenden Details angeben:

- **name**: Der Name deiner Umgebung (z. B. „Johns Aquarium“).
- **description**: Eine kurze Beschreibung der Umgebung (z. B. „Mein Salzwasserriffbecken“).
- **environment_type**: Der Typ der Umgebung, den du erstellst. Wähle aus den folgenden Optionen:
  - `aquarium`
  - `pond`
  - `lake`
  - `sea`
  - `pool`
  - `other`
- **city**: (Optional) Die Stadt, in der sich die Umgebung befindet.

### Beispiel-Request-Body

```json
{
  "name": "Johns Aquarium",
  "description": "Mein Salzwasserriffbecken",
  "environment_type": "aquarium",
  "city": "New York"
}
```

### Beispielanfrage

So kannst du eine Umgebung mithilfe der API erstellen:

```bash
POST https://dev.aquaware.cloud/api/environments/
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Antwort

Bei Erfolg gibt der Server einen Status `201 Created` zurück, zusammen mit Details zur neu erstellten Umgebung.

---

Wenn du Fragen hast oder Hilfe benötigst, schau dir unsere [API-Dokumentation](#) an oder kontaktiere den Support.
