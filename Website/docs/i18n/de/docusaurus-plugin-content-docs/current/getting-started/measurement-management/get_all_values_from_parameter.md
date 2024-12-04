---
sidebar_position: 2
---

# Get All Values From Parameter

The **Get All Values From Parameter** endpoint allows you to retrieve all water values for a specific parameter in an environment. This is useful for monitoring trends over time, for example, checking how the pH level or temperature of the water has changed.

## Endpoint

`GET /measurements/environments/<int:environment_id>/water-values/<str:parameter_name>/<int:number_of_entries>/`

## Request Parameters

1. **environment_id**: The ID of the environment from which you want to retrieve the water values. This is required and should be an integer.
2. **parameter_name**: The name of the water parameter you want to retrieve. This must be a string and match one of the supported water parameters listed below.
3. **number_of_entries**: The number of latest entries you want to retrieve for the specified parameter. This is required and should be an integer.

## Headers

| Name          | Type   | Description                                     |
| ------------- | ------ | ----------------------------------------------- |
| Authorization | string | Bearer token for authentication (Access Token). |
| Content-Type  | string | Must be set to `application/json`.              |

## Example Request

```bash
curl -X GET "https://dev.aquaware.cloud/api/measurements/environments/123/water-values/PH/3/" \
-H "Authorization: Bearer <your_access_token>" \
-H "Content-Type: application/json"
```

## Example Response

```json
{
  "parameter": "PH",
  "values": [
    {
      "measured_at": "2023-09-20T12:45:00Z",
      "value": 7.5,
      "unit": "pH"
    },
    {
      "measured_at": "2023-09-19T12:45:00Z",
      "value": 7.6,
      "unit": "pH"
    },
    {
      "measured_at": "2023-09-18T12:45:00Z",
      "value": 7.4,
      "unit": "pH"
    }
  ]
}
```

In the above example, we retrieved the last 3 pH values from environment 123.
Each entry contains the time the measurement was taken (`measured_at`), the value (`value`), and the unit of measurement (`unit`).
