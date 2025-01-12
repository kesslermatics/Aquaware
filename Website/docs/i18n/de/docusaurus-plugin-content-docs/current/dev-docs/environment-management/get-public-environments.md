---
sidebar_position: 5
---

# Alle öffentlichen Umgebungen abrufen

Um eine Liste aller öffentlich verfügbaren Umgebungen zu erhalten, kannst du diesen API-Endpunkt nutzen:

- **URL:** `https://dev.aquaware.cloud/api/environments/public/`
- **Methode:** `GET`
- **Authentifizierung:** Du musst dein JWT **Access Token** in die Header der Anfrage einfügen. Mehr Infos zu [JWT Tokens findest du hier](../user-management/jwt-tokens.md).

## Was du bekommst

Die API liefert eine Liste von Umgebungen, die öffentlich verfügbar sind, aber **nicht** dem authentifizierten Nutzer gehören. Das ist nützlich, wenn du öffentliche Daten wie die Wassertemperatur in nahegelegenen Seen oder anderen öffentlichen Gewässern einsehen möchtest.

### Beispielanfrage

```bash
GET https://dev.aquaware.cloud/api/environments/public/
Authorization: Bearer <access_token>
```

### Beispielantwort

```json
[
  {
    "id": 2,
    "name": "Öffentlicher See",
    "description": "Ein lokaler See, der öffentlich einsehbar ist",
    "environment_type": "lake",
    "city": "Heilbronn",
    "date_created": "2024-08-15T08:21:00Z"
  },
  {
    "id": 5,
    "name": "Gemeinschaftspool",
    "description": "Öffentlicher Pool mit einsehbaren Wasserwerten",
    "environment_type": "pool",
    "city": "New York",
    "date_created": "2024-07-12T09:34:00Z"
  }
]
```
