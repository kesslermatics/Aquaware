---
sidebar_position: 8
---

# Get Alert Settings

Alerts are only available in the **Advanced** or **Business** plan. You can retrieve the current alert threshold settings for any water parameter within your environment. Alerts will notify you via email when thresholds are crossed, sent to your registered email address.

## API Endpoint

`GET /environments/<environment_id>/get_alerts/<parameter_name>/`

### Example

```bash
curl -X GET "https://dev.aquaware.cloud/api/environments/<environment_id>/get_alerts/pH/" \
-H "Authorization: Bearer <your_access_token>"
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
