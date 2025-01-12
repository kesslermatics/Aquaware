---
sidebar_position: 8
---

# Alarm-Einstellungen abrufen

Alarme sind nur im **Advanced**- oder **Premium**-Plan verfügbar. Du kannst die aktuellen Alarm-Schwellenwerte für jeden Wasserparameter in deiner Umgebung abrufen. Alarme benachrichtigen dich per E-Mail, wenn Schwellenwerte überschritten werden, und die E-Mails werden an deine registrierte E-Mail-Adresse gesendet.

## API-Endpunkt

`GET /api/environments/<int:environment_id>/values/alerts/<str:parameter_name>/`

### Beispiel

```bash
curl -X GET "https://dev.aquaware.cloud/api/environments/3/values/alerts/pH/" -H "x-api-key: <api_key>"
```

## Antwort

```json
{
  "parameter": "pH",
  "under_value": 6.5,
  "above_value": 8.0
}
```

- **200 OK**: Alarmeinstellungen erfolgreich abgerufen.
- **404 Not Found**: Keine Alarmeinstellungen für den angegebenen Parameter oder die Umgebung gefunden.
- **400 Bad Request**: Ungültige Eingabe oder Parameter.
