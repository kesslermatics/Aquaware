---
sidebar_position: 4
---

# Neueste Werte aller Parameter abrufen

### Endpunkt

`GET /api/environments/<int:environment_id>/values/latest/<int:number_of_entries>/`

### Beschreibung

Diese API ruft die neuesten Werte aller Wasserparameter in einer gegebenen Umgebung ab. Besonders nützlich für Dashboards, bei denen Benutzer auf einen Blick die neuesten Messungen aller überwachten Parameter sehen möchten.

### Authentifizierung

API-Schlüssel

### Anfrageparameter

- **environment_id**: Die ID der Umgebung (Ganzzahl)
- **number_of_entries**: Die Anzahl der neuesten Einträge, die abgerufen werden sollen (Ganzzahl)

### Beispielanfrage

```
GET /api/environments/1/values/latest/10/
```

### Antwort

- **200 OK**: Neueste Werte für jeden Parameter werden zurückgegeben.

```json
[
  {
    "parameter": "pH",
    "values": [
      {
        "measured_at": "2024-09-24T10:30:00Z",
        "value": 7.2,
        "unit": "pH"
      },
      {
        "measured_at": "2024-09-23T10:30:00Z",
        "value": 7.0,
        "unit": "pH"
      }
    ]
  },
  {
    "parameter": "Temperature",
    "values": [
      {
        "measured_at": "2024-09-24T10:30:00Z",
        "value": 24.5,
        "unit": "C"
      }
    ]
  }
]
```

- **404 Not Found**: Die Umgebung wurde nicht gefunden.
- **400 Bad Request**: Ungültige Anfrageparameter.

### Anwendungsfall

Dieser Endpunkt ist ideal für Echtzeit-Monitoring-Dashboards, bei denen Benutzer schnell die neuesten Wasserparameterwerte aller Parameter in einer Umgebung sehen möchten. Besonders nützlich, wenn du die aktuellen Bedingungen in einer Umgebung überprüfen willst, ohne historische Daten für jeden Parameter einzeln zu durchsuchen.
