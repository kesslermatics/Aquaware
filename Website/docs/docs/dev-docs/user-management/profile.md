---
sidebar_position: 5
---

# Profile

The Aquaware API allows you to fetch details about your user profile using the `/api/users/profile` endpoint. This endpoint provides essential user information, such as email, name, account creation date, API key, and subscription tier.

## Fetching Your Profile Information

You can retrieve your profile information using the following API endpoint:

- **URL:** `http://dev.aquaware.cloud/api/users/profile/`
- **Method:** `GET`
- **Authorization:** Requires a valid JWT token in the request header.

### Example Request

To fetch your profile details, include your JWT token in the `Authorization` header of the request.

```bash
GET http://dev.aquaware.cloud/api/users/profile/
Authorization: Bearer <your-jwt-token>
```

### Response

Upon a successful request, the API will return the following user details in JSON format:

- `email`: Your registered email address.
- `first_name`: Your first name.
- `last_name`: Your last name.
- `date_joined`: The date and time your account was created.
- `api_key`: Your unique API key for programmatic access.
- `subscription_tier`: Your current subscription plan (e.g., "Hobby", "Advanced", "Premium").

### Example Response

```json
{
  "email": "john.doe@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "date_joined": "2023-12-01T14:32:00Z",
  "api_key": "abcd1234efgh5678ijkl",
  "subscription_tier": "Hobby"
}
```

### Notes

- Ensure your JWT token is valid; expired or invalid tokens will result in an authentication error.
- The `api_key` is a sensitive value. Do not share it publicly, as it provides access to your Aquaware account.
- The `subscription_tier` value may affect access to certain features or APIs.