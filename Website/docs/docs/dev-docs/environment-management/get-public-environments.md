---
sidebar_position: 5
---

# Get All Public Environments

To retrieve a list of all publicly available environments, you can use the following API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/public/`
- **Method:** `GET`
- **Authentication:** You must include your JWT **Access Token** in the request headers. Learn more about [JWT tokens here](../user-management/jwt-tokens.md).

## What You Get

The API will return a list of environments that are publicly available but **do not** belong to the authenticated user. This is useful for users who want to view public data such as water temperature in nearby lakes or other public water bodies.

### Example Request

```bash
GET https://dev.aquaware.cloud/api/environments/public/
Authorization: Bearer <access_token>
```

### Example Response

```json
[
  {
    "id": 2,
    "name": "Public Lake",
    "description": "A local lake that is publicly viewable",
    "environment_type": "lake",
    "city": "Heilbronn",
    "date_created": "2024-08-15T08:21:00Z"
  },
  {
    "id": 5,
    "name": "Community Pool",
    "description": "Public pool available for viewing water data",
    "environment_type": "pool",
    "is_public": "New York",
    "date_created": "2024-07-12T09:34:00Z"
  }
]
```
