---
sidebar_position: 4
---

# Refresh Access Token

The **Refresh Access Token** process is essential to keep your session alive without requiring a new login each time your access token expires. By using the refresh token, a new access token can be generated to ensure continuous authentication.

### Endpoint

```
POST https://dev.aquaware.cloud/api/users/auth/token/refresh/
```

### Request Body

The request body contains the refresh token that was issued during the initial authentication:

```json
{
  "refresh": "your_refresh_token"
}
```

**Example:**

In Postman or any API client, you can send a POST request to refresh your access token as shown in the screenshot:

- Method: `POST`
- URL: `https://dev.aquaware.cloud/api/users/auth/token/refresh/
- Body: form-data with `refresh` key and your refresh token.

### Response

If the request is successful, a new access token is returned:

```json
{
  "access": "new_access_token"
}
```

### Token Lifecycle

The **Access Token** typically has a short lifespan (e.g., 5 to 30 minutes). When it expires, you can request a new access token using the **Refresh Token**, which has a much longer expiration time (e.g., 7 days or more).

### Security Tip

:::tip
It’s a good practice to store the **Refresh Token** securely, either in **local storage** or in a secure cookie. However, never store tokens in a way that they could be accessed by unintended third parties.
:::

By keeping the refresh token, you can remain logged in without frequently re-entering credentials.

### Authorization Header

When making further requests, remember to pass the newly issued access token in the `Authorization` header:

```
Authorization: Bearer new_access_token
```

This way, you can authenticate API requests with the newly refreshed token.
