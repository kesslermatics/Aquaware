---
sidebar_position: 2
---

# Login

To access your Aquaware account, you can log in either through our website, the app or programmatically using our API. After logging in, you'll receive JWT tokens, which are **crucial for future authorization**.

## Logging in via the API

You can log in using the following API endpoint:

- **URL:** `http://dev.aquaware.cloud/api/users/auth/login/`
- **Method:** `POST`
- **Content-Type:** `multipart/form-data`

### Example Request

You need to provide your email and password in the request body to log in.

```bash
POST http://dev.aquaware.cloud/api/users/auth/login/
Content-Type: multipart/form-data
```

### Request Body

The request body should contain the following fields:

- `email`: Your registered email address
- `password`: Your account password

### Example Request Body

```json
{
  "email": "john.doe@example.com",
  "password": "SuperSecurePassword123!"
}
```

### Response

Upon successful login, you will receive your JWT tokens, which will be used for future authorization.

### Managing Your Profile

Once logged in, you can manage your profile by visiting the [Aquaware Profile Management Page](https://aquaware.cloud/login).

For more information on how JWT tokens work and how they are used for authorization, check out the documentation [here](./jwt-tokens).

---

If you have any issues or need help, feel free to check our [documentation](#) or contact our support team.
