---
sidebar_position: 2
---

# Get All of My Environments

To retrieve a list of all the environments associated with your account, you can use the following API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/`
- **Method:** `GET`
- **Authentication:** You must include your JWT **Access Token** in the request headers. Learn more about [JWT tokens here](../user-management/jwt-tokens.md).

## Response

This endpoint will return a list of all environments you have created, along with their details such as:

- **Environment ID**: A unique identifier for the environment.
- **Name**: The name of the environment (e.g., "My Aquarium").
- **Description**: A brief description of the environment.
- **Environment Type**: The type of environment (e.g., "lake", "aquarium").
- **City**: The city which is the hometown of this environment.
- **Date Created**: When the environment was created.

### Example Response

```json
[
  {
    "id": 1,
    "name": "John's Aquarium",
    "description": "My saltwater reef tank",
    "environment_type": "aquarium",
    "city": "New York",
    "date_created": "2024-09-23T12:34:56Z"
  },
  {
    "id": 2,
    "name": "Public Lake",
    "description": "A local lake that is publicly viewable",
    "environment_type": "lake",
    "city": "Heilbronn",
    "date_created": "2024-08-15T08:21:00Z"
  }
]
```

:::tip

This endpoint is especially useful if you need to find the **Environment ID** for a specific environment. You will need the environment ID when performing further actions, such as adding water values or retrieving detailed information about the environment.

:::

---

For more information regarding the info of your environments, please contact our support team :)
