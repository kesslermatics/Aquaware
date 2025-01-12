---
sidebar_position: 7
---

# Alarm-Einstellungen speichern

Alarme sind nur im **Advanced**- oder **Premium**-Plan verfügbar. Du kannst Schwellenwertalarme für deine Wasserparameter entweder über die API oder direkt in der App einstellen. Sobald festgelegt, benachrichtigen dich Alarme per E-Mail, wenn ein Wasserparameter den definierten Schwellenwert überschreitet. Die E-Mails werden an die registrierte E-Mail-Adresse des Kontos gesendet.

## API-Endpunkt

`POST /api/environments/<int:environment_id>/values/alerts/`

### Anfrage-Body

```json
{
  "parameter": "<parameter_name>",
  "under_value": "<threshold_under_value>",
  "above_value": "<threshold_above_value>"
}
```

### Beispiel

```bash
curl -X POST "https://dev.aquaware.cloud/api/environments/PH/values/alerts/" -H "x-api-key: <api-key>" -H "Content-Type: application/json" -d '{
    "parameter": "pH",
    "under_value": 6.5,
    "above_value": 8.0
}'
```

## Antwort

- **200 OK**: Alarmeinstellungen erfolgreich gespeichert.
- **400 Bad Request**: Ungültige Eingabe.
- **404 Not Found**: Umgebung nicht gefunden.
