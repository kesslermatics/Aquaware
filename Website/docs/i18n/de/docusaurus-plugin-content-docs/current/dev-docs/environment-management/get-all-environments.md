---
sidebar_position: 2
---

# Alle meine Umgebungen abrufen

Um eine Liste aller Umgebungen zu erhalten, die deinem Konto zugeordnet sind, kannst du diesen API-Endpunkt verwenden:

- **URL:** `https://dev.aquaware.cloud/api/environments/`
- **Methode:** `GET`
- **Authentifizierung:** Du musst deinen API-Schlüssel mit angeben

## Antwort

Dieser Endpunkt liefert dir eine Liste aller Umgebungen, die du erstellt hast, inklusive folgender Details:

- **Environment ID**: Eine eindeutige Kennung für die Umgebung.
- **Name**: Der Name der Umgebung (z. B. „Mein Aquarium“).
- **Beschreibung**: Eine kurze Beschreibung der Umgebung.
- **Environment Type**: Der Typ der Umgebung (z. B. „lake“, „aquarium“).
- **City**: Die Stadt, in der sich die Umgebung befindet.
- **Datum der Erstellung**: Wann die Umgebung erstellt wurde.

### Beispielantwort

```json
[
  {
    "id": 1,
    "name": "Johns Aquarium",
    "description": "Mein Salzwasserriffbecken",
    "environment_type": "aquarium",
    "city": "New York",
    "date_created": "2024-09-23T12:34:56Z"
  },
  {
    "id": 2,
    "name": "Öffentlicher See",
    "description": "Ein lokaler See, der öffentlich einsehbar ist",
    "environment_type": "lake",
    "city": "Heilbronn",
    "date_created": "2024-08-15T08:21:00Z"
  }
]
```

:::tip

Dieser Endpunkt ist besonders nützlich, wenn du die **Environment ID** für eine spezifische Umgebung finden willst. Die ID brauchst du für weitere Aktionen, wie das Hinzufügen von Wasserwerten oder das Abrufen detaillierter Informationen.

:::

---

Wenn du mehr Infos zu deinen Umgebungen benötigst, kontaktiere unser Support-Team :)
