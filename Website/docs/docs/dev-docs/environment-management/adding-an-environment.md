---
sidebar_position: 1
---

# How to add an Environment

Adding an environment in Aquaware is simple and can be done either via the Aquaware app or through our API.

## Adding an Environment via the App

You can easily create an environment through our mobile app by navigating to the **"Add Environment"** section. This feature allows you to quickly set up your aquarium, lake, or other water environments directly from your device.

## Adding an Environment via the API

If you prefer to add an environment programmatically, you can use our API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Authentication:** You must include your API-Key

### Required Fields

When creating an environment, you need to provide the following details:

- **name**: The name of your environment (e.g., "John's Aquarium").
- **description**: A short description of the environment (e.g., "My saltwater reef tank").
- **environment_type**: The type of environment you're creating. Choose from the following:
  - `aquarium`
  - `pond`
  - `lake`
  - `sea`
  - `pool`
  - `other`
- **city**: (Optional) The city which is the hometown of this environment

### Example Request Body

```json
{
  "name": "John's Aquarium",
  "description": "My saltwater reef tank",
  "environment_type": "aquarium",
  "city": "New York"
}
```

### Example Request

Here's how you can create an environment using the API:

```bash
POST https://dev.aquaware.cloud/api/environments/
X-API-KEY: <your-api-key>
Content-Type: application/json
```

### Response

On success, the server will return a `201 Created` status with details about the newly created environment.

---

If you have any issues or need help, feel free to check our [API documentation](#) or contact support.
