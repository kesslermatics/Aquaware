---
sidebar_position: 3
---

# Gesamtanzahl der Einträge für einen Parameter abrufen

### Endpunkt

`GET /api/environments/<int:environment_id>/values/parameters/<str:parameter_name>/total/`

### Beschreibung

Diese API gibt die Gesamtanzahl der Einträge zurück, die für einen bestimmten Wasserparameter in einer Umgebung aufgezeichnet wurden. Nützlich, um die Häufigkeit der Parameter-Messungen zu verfolgen.

### Authentifizierung

API-Schlüssel

### Anfrageparameter

- **environment_id**: Die ID der Umgebung (Ganzzahl)
- **parameter_name**: Der Name des Wasserparameters (String)

### Beispielanfrage

```
GET /api/environments/1/values/parameters/PH/total/
```

### Antwort

- **200 OK**: Gesamtanzahl der Einträge wird zurückgegeben.

```json
{
  "total_entries": 120
}
```

- **404 Not Found**: Die Umgebung oder der Parameter wurde nicht gefunden.
- **400 Bad Request**: Ungültige Anfrageparameter.

### Anwendungsfall

Dieser Endpunkt ist hilfreich, wenn du überprüfen möchtest, wie oft ein bestimmter Parameter, wie pH oder Temperatur, in einer Umgebung gemessen wurde. Er liefert die Gesamtanzahl der aufgezeichneten Werte für diesen Parameter.
