---
sidebar_position: 3
---

# Update My Environment

To update an environment that you have previously created, you can use the following API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/<int:id>/`
- **Method:** `PUT`
- **Authentication:** You must include your JWT **Access Token** in the request headers. Learn more about [JWT tokens here](../user-management/jwt-tokens.md).

## What You Can Update

The API allows you to update any of the following fields in your environment:

- **name**: The name of your environment (e.g., "My Updated Aquarium").
- **description**: A brief description of the environment.
- **environment_type**: The type of environment (`aquarium`, `lake`, `sea`, `pool`, `other`).
- **city**: The hometown city of your environment

You do not need to provide all fields in the request body; you can update only the parts you wish to change (i.e., **partial updates** are allowed).

### Example Request

```bash
PUT https://dev.aquaware.cloud/api/environments/1/
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Example Request Body

You can include only the fields you want to update:

```json
{
  "name": "My Updated Aquarium",
  "description": "Updated description of my aquarium"
}
```

In this case, only the name and description fields will be updated.

### Example Response

```json
{
  "id": 1,
  "name": "My Updated Aquarium",
  "description": "Updated description of my aquarium",
  "environment_type": "aquarium",
  "city": "New York",
  "date_created": "2024-09-23T12:34:56Z"
}
```

### Error Handling

If the environment does not belong to you or the ID does not exist, the API will return a `404 Not Found` error.

```json
{
  "error": "Environment not found or does not belong to this user."
}
```

If there are any validation errors, the API will return a `400 Bad Request` error with the specific validation messages.
