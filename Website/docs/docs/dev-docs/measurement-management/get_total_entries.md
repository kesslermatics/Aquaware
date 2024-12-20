---
sidebar_position: 3
---

# Get Total Entries for a Parameter

### Endpoint

`GET /api/environments/<int:environment_id>/values/parameters/<str:parameter_name>/total/`

### Description

This API retrieves the total number of entries recorded for a specific water parameter in an environment. Useful for tracking the frequency of parameter measurements.

### Authentication

API Key

### Request Parameters

- **environment_id**: The ID of the environment (integer)
- **parameter_name**: The name of the water parameter (string)
-

### Example Request

```
GET /api/environments/1/values/parameters/PH/total/
```

### Response

- **200 OK**: Total number of entries returned.

```json
{
  "total_entries": 120
}
```

- **404 Not Found**: The environment or parameter was not found.
- **400 Bad Request**: Invalid request parameters.

### Use Case

This endpoint can be helpful when you want to check how often a specific parameter, like pH or temperature, has been measured in an environment. It gives you the total count of recorded values for that parameter.
