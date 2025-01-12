---
sidebar_position: 3
---

# Aktualisiere deine Umgebung

Wenn du eine Umgebung updaten willst, die du schon vorher erstellt hast, kannst du einfach diesen API-Endpunkt nutzen:

- **URL:** `https://dev.aquaware.cloud/api/environments/<int:id>/`
- **Methode:** `PUT`
- **Authentifizierung:** Du brauchst ein JWT **Access Token** in den Headern der Anfrage. Mehr Infos zu [JWT Tokens findest du hier](../user-management/jwt-tokens.md).

## Was du ändern kannst

Mit der API kannst du die folgenden Felder in deiner Umgebung anpassen:

- **name**: Der Name deiner Umgebung (z. B. „Mein aktualisiertes Aquarium“).
- **description**: Eine kurze Beschreibung der Umgebung.
- **environment_type**: Der Typ der Umgebung (`aquarium`, `lake`, `sea`, `pool`, `other`).
- **city**: Die Stadt, in der sich deine Umgebung befindet.

Du musst nicht alle Felder in der Anfrage mitschicken. Änder einfach nur das, was du möchtest (**partielle Updates** sind erlaubt).

### Beispiel-Anfrage

```bash
PUT https://dev.aquaware.cloud/api/environments/1/
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Beispiel-Anfrage-Body

Schick nur die Felder, die du ändern willst:

```json
{
  "name": "Mein aktualisiertes Aquarium",
  "description": "Aktualisierte Beschreibung meines Aquariums"
}
```

In diesem Fall werden nur der Name und die Beschreibung aktualisiert.

### Beispiel-Antwort

```json
{
  "id": 1,
  "name": "Mein aktualisiertes Aquarium",
  "description": "Aktualisierte Beschreibung meines Aquariums",
  "environment_type": "aquarium",
  "city": "New York",
  "date_created": "2024-09-23T12:34:56Z"
}
```

### Fehlerbehandlung

Wenn die Umgebung nicht dir gehört oder die ID nicht existiert, bekommst du einen `404 Not Found`-Fehler.

```json
{
  "error": "Umgebung nicht gefunden oder gehört nicht diesem Nutzer."
}
```

Falls es Validierungsfehler gibt, bekommst du einen `400 Bad Request`-Fehler mit den spezifischen Fehlermeldungen.
