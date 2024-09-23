---
sidebar_position: 1
---

# How to add an Environment

Adding an environment in Aquaware is simple and can be done either via the Aquaware app or through our API.

## Adding an Environment via the App

You can easily create an environment through our mobile app by navigating to the **"Add Environment"** section. This feature allows you to quickly set up your aquarium, lake, or other water environments directly from your device.

## Adding an Environment via the API

If you prefer to add an environment programmatically, you can use our API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/create/`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Authentication:** You must include your JWT **Access Token** in the request headers. Read more about [JWT tokens here](../user-management/jwt-tokens).

### Required Fields

When creating an environment, you need to provide the following details:

- **name**: The name of your environment (e.g., "John's Aquarium").
- **description**: A short description of the environment (e.g., "My saltwater reef tank").
- **environment_type**: The type of environment you're creating. Choose from the following:
  - `aquarium`
  - `lake`
  - `sea`
  - `pool`
  - `other`
- **is_public**: A boolean value (`true` or `false`). By default, environments are set to `false`, meaning they are private. If you're on a **Business Plan**, you can set this to `true` to make your environment public so others in the area can view the water data.

### Example Request Body

```json
{
  "name": "John's Aquarium",
  "description": "My saltwater reef tank",
  "environment_type": "aquarium",
  "is_public": false
}
```

### Example Request

Here's how you can create an environment using the API:

```bash
POST https://dev.aquaware.cloud/api/environments/create/
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Response

On success, the server will return a `201 Created` status with details about the newly created environment.

## Making Environments Public

If you're on a **Business Plan**, you can choose to make your environment public by setting `is_public` to `true`. This is particularly useful for public lakes or other water bodies where people may want to access the water quality data. For example, visitors to a public lake can easily check water quality before planning their trip.

---

If you have any issues or need help, feel free to check our [API documentation](#) or contact support.
