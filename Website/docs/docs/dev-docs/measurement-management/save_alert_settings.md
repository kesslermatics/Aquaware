---
sidebar_position: 7
---

# Save Alert Settings

Alerts are only available in the **Advanced** or **Premium** plan. You can set threshold alerts for your water parameters through the API or directly in the app. Once set, alerts will notify you via email when a water parameter exceeds the defined threshold. The emails are sent to the account's registered email address.

## API Endpoint

`POST /api/environments/<int:environment_id>/values/alerts/`

### Request Body

```json
{
  "parameter": "<parameter_name>",
  "under_value": "<threshold_under_value>",
  "above_value": "<threshold_above_value>"
}
```

### Example

```bash
curl -X POST "https://dev.aquaware.cloud/api/environments/PH/values/alerts/" \
-H "x-api-key: <api-key>" \
-H "Content-Type: application/json" \
-d '{
    "parameter": "pH",
    "under_value": 6.5,
    "above_value": 8.0
}'
```

## Response

- **200 OK**: Alert settings saved successfully.
- **400 Bad Request**: Invalid input.
- **404 Not Found**: Environment not found.
