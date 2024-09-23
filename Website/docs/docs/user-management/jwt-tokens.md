---
sidebar_position: 3
---

# JWT-Tokens

# Understanding JWT Tokens

When you log into Aquaware, you receive **JWT Tokens** that are essential for authenticating and authorizing your requests to the API. JWT (JSON Web Token) is a secure, compact token format used to represent information between two parties.

## Types of JWT Tokens

Aquaware provides two types of JWT tokens:

### Access Token

- This token is used for authenticating your API requests. It has a **short lifespan** (e.g., 5 minutes) to ensure security.
- You must include the access token in the **Authorization Bearer Header** of every request that requires authentication.

### Refresh Token

- This token is used to **renew** your access token when it expires. It has a **longer lifespan** (e.g., several days/months/years) and can be used to request a new access token without needing to log in again.

:::tip

Store the refresh token locally (e.g., in local storage or a secure cookie) to maintain your session and avoid being logged out. This allows you to request new access tokens without re-entering your credentials.

:::

### Example: Using Authorization Header

When making an API request, you must send the access token in the request header using the `Authorization: Bearer` scheme, like so:

```bash
Authorization: Bearer <access_token>
```

## Access Token vs. Refresh Token

| **Aspect**      | **Access Token**                                    | **Refresh Token**                      |
| --------------- | --------------------------------------------------- | -------------------------------------- |
| **Purpose**     | Used for making authenticated API requests          | Used for generating a new access token |
| **Lifespan**    | Short-lived (e.g., 15 minutes)                      | Longer-lived (e.g., several days)      |
| **Location**    | Sent with every request in the Authorization header | Stored locally (e.g., local storage)   |
| **When to Use** | On every authenticated API call                     | When the access token expires          |
