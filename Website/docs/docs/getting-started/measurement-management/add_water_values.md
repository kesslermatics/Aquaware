---
sidebar_position: 1
---

# Add Water Values

## Endpoint

`POST /measurements/add/<int:environment_id>/`

## Description

This endpoint allows you to add water values to a specific environment. Each environment belongs to a user, and you can only submit water values based on the upload frequency defined by your subscription tier. This ensures resource conservation and prevents spamming of the API.

### Upload Frequency

- **Hobby Plan**: Can upload new water values every 2 hours.
- **Business Plan**: Can upload new water values every 30 minutes.
- **Advanced Plan**: Can upload new water values every 30 minutes.

If you try to submit values before the allowed time frame, you'll receive a `429 Too Many Requests` error.

### Water Parameters

The following water parameters are currently supported by the system. Each parameter has an associated unit:

| Parameter Name     | Unit  |
| ------------------ | ----- |
| PH                 | pH    |
| Temperature        | °C    |
| TDS                | ppm   |
| Oxygen             | mg/L  |
| Ammonia            | ppm   |
| Nitrite            | ppm   |
| Nitrate            | ppm   |
| Phosphate          | ppm   |
| Carbon Dioxide     | mg/L  |
| Salinity           | ppt   |
| General Hardness   | dGH   |
| Carbonate Hardness | dKH   |
| Copper             | ppm   |
| Iron               | ppm   |
| Calcium            | ppm   |
| Magnesium          | ppm   |
| Potassium          | ppm   |
| Chlorine           | ppm   |
| Redox Potential    | mV    |
| Silica             | ppm   |
| Boron              | ppm   |
| Strontium          | ppm   |
| Iodine             | ppm   |
| Molybdenum         | ppm   |
| Sulfate            | ppm   |
| Organic Carbon     | ppm   |
| Turbidity          | NTU   |
| Conductivity       | µS/cm |
| Suspended Solids   | mg/L  |
| Fluoride           | ppm   |
| Bromine            | ppm   |
| Chloride           | ppm   |

### Authentication

- **JWT Access Token**: You need to be authenticated with your JWT access token to submit water values. See [JWT Tokens](../user-management/jwt-tokens.md) for more details.

## Request Example

Here’s an example request to add water values for an environment:

### Request URL

```
POST /measurements/add/3/
```

### Request Body

```json
{
  "Temperature": 29.9,
  "PH": 8.2,
  "TDS": 630
}
```

## Response

- **201 Created**: Water values were successfully added.
- **400 Bad Request**: There was an error with the request, such as missing or invalid fields.
- **404 Not Found**: The environment does not exist or does not belong to the user.
- **429 Too Many Requests**: You are trying to submit values before the allowed upload frequency time.

## Example Response

```json
{
    "id": 4,
    "environment": 3,
    "parameter": {
        "id": 1,
        "name": "PH",
        "unit": "pH"
    },
    "value": "8.200",
    "measured_at": "2024-09-23T11:19:09.432111Z"
},
{
    "id": 5,
    "environment": 3,
    "parameter": {
        "id": 2,
        "name": "Temperature",
        "unit": "°C"
    },
    "value": "29.900",
    "measured_at": "2024-09-23T11:19:09.432111Z"
},
{
    "id": 6,
    "environment": 3,
    "parameter": {
        "id": 3,
        "name": "TDS",
        "unit": "ppm"
    },
    "value": "630.000",
    "measured_at": "2024-09-23T11:19:09.432111Z"
}
```
