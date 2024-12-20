---
sidebar_position: 8
---

# Get Alert Settings

Alerts are only available in the **Advanced** or **Premium** plan. You can retrieve the current alert threshold settings for any water parameter within your environment. Alerts will notify you via email when thresholds are crossed, sent to your registered email address.

## API Endpoint

`GET /api/environments/<int:environment_id>/values/alerts/<str:parameter_name>/`

### Example

```bash
curl -X GET "https://dev.aquaware.cloud/api/environments/3/values/alerts/pH/" \
-H "x-api-key: <api_key>"
```

## Response

```json
{
  "parameter": "pH",
  "under_value": 6.5,
  "above_value": 8.0
}
```

- **200 OK**: Successfully retrieved alert settings.
- **404 Not Found**: No alert settings found for the specified parameter or environment.
- **400 Bad Request**: Invalid input or parameter.
