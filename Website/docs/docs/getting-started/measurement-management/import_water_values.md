---
sidebar_position: 6
---

# Import Water Values

### Endpoint

`POST /measurements/environments/<int:environment_id>/import/`

### Description:

This API allows users to import water values into an environment by uploading a CSV file. It's useful for migrating data or adding bulk water values from another source.

### Authentication

JWT Token (Access Token required)

### Request Parameters

- **environment_id**: The ID of the environment (integer)
- **file**: A CSV file containing the water values (the file should include columns like "Measured At", parameter names, and their values).

### Example Request

```
POST /measurements/environments/1234/import/
```

### Example CSV Format

```
Measured At,pH,Temperature,pH_unit,Temperature_unit
2024-09-24 10:30:00,7.2,24.5,pH,C
2024-09-23 10:30:00,7.0,24.2,pH,C
```

### Response

- **201 Created**: Water values successfully imported.
- **400 Bad Request**: The CSV file format is invalid or there is an issue with the data.
- **429 Too Many Requests**: Water values were uploaded too frequently (based on the user’s subscription).

### Use Case

This API is ideal for users who want to import bulk data from other sources or systems into their Aquaware environment. It's a great way to migrate historical water data efficiently.
