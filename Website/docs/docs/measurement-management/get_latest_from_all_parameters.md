---
sidebar_position: 4
---

# Get Latest Values from All Parameters

### Endpoint

`GET /measurements/environments/<int:environment_id>/water-values/<int:number_of_entries>/`

### Description

This API retrieves the latest values for all water parameters in a given environment. It is particularly useful for dashboard views, where users want to see the most recent measurements of all monitored parameters at a glance.

### Authentication

JWT Token (Access Token required)

### Request Parameters

- **environment_id**: The ID of the environment (integer)
- **number_of_entries**: The number of most recent entries to retrieve (integer)

### Example Request

```
GET /measurements/environments/1234/water-values/10/
```

### Response

- **200 OK**: Latest values for each parameter returned.

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

- **404 Not Found**: The environment was not found.
- **400 Bad Request**: Invalid request parameters.

### Use Case

This endpoint is ideal for real-time monitoring dashboards, allowing users to quickly view the most recent water parameter readings for all the parameters in an environment. It's particularly useful when you want to check the latest conditions in an environment without delving into historical data for each parameter.
