---
sidebar_position: 5
---

# Export Water Values

### Endpoint

`GET /measurements/environments/<int:environment_id>/export/`

### Description

This API allows users to export the water values of an environment as a CSV file. It is particularly useful for backing up data, sharing with third parties, or for further data analysis in spreadsheet software.

### Authentication

JWT Token (Access Token required)

### Request Parameters

- **environment_id**: The ID of the environment (integer)

### Example Request

```
GET /measurements/environments/1234/export/
```

### Response

- **200 OK**: Returns a CSV file containing water values for the environment.

```
Measured At, pH, Temperature, pH_unit, Temperature_unit
2024-09-24 10:30:00, 7.2, 24.5, pH, C
2024-09-23 10:30:00, 7.0, 24.2, pH, C
```

- **404 Not Found**: The environment was not found or does not belong to the user.
- **400 Bad Request**: Invalid request.

:::danger[Keep in mind]

When using an Arduino to upload water values asynchronously, it's possible that the values for different parameters might have a time difference of a few seconds. This can lead to slight discrepancies in the time recorded for each parameter. To mitigate this, we have implemented a system that groups all measurements taken within a 5-minute window. This means that exported measurements will always be summarized and exist within 5-minute intervals, ensuring consistency across parameters and reducing the impact of small time differences.

:::
