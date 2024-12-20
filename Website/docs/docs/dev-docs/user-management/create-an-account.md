---
sidebar_position: 1
---

# Create an Account

Creating an account with Aquaware is simple and can be done in just a few steps. You can either sign up directly through our website or, soon, directly through the app.

## How to Create an Account

To create an account, head over to the [Aquaware Signup Page](https://aquaware.cloud/signup). Alternatively, you can create an account programmatically by sending a request to our API.

### API Signup

You can use the following API endpoint to create an account:

- **URL:** `https://dev.aquaware.cloud/api/users/auth/signup/`
- **Method:** `POST`
- **Content-Type:** `application/json`

### Example Request

Here is an example request to create an account using the API:

```bash
POST https://dev.aquaware.cloud/api/users/auth/signup/
Content-Type: application/json
```

### Request Body

The request body should contain the following fields in JSON format:

```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "password": "SuperSecurePassword123!",
  "password2": "SuperSecurePassword123!"
}
```

### Password Requirements

The password must meet certain criteria to ensure security. We use **Django's password validation** to enforce the following rules:

- **Minimum Length:** The password must be at least 8 characters long.
- **Complexity:** It must contain a mix of uppercase and lowercase letters, at least one digit, and at least one special character (e.g., `@`, `!`, `#`, `$`).
- **Validation:** The \`password\` and \`password2\` fields must match to ensure you've correctly confirmed your password.

If the password does not meet these requirements, the API will return an error with details on what needs to be fixed.

### Response

A successful account creation will return a \`201 Created\` status code and a response like this:

```json
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "date_joined": "2024-09-20T12:00:00Z"
}
```

## Password Security

At Aquaware, we take password security seriously to ensure your data is protected. Here's how we handle passwords:

### How Passwords Are Stored

1. **Password Hashing**: We do not store passwords in plain text. Instead, passwords are hashed using a strong one-way cryptographic hashing algorithm.
2. **Salted Hashing**: Each password is combined with a unique salt, which adds an extra layer of security against pre-computed attacks (such as rainbow table attacks).
3. **Django's Password Validation**: Passwords are validated and stored following Django's built-in security features, ensuring compliance with best practices in password storage and encryption.

### Security Features

- **Strong Hashing Algorithm**: We use secure hashing algorithms like PBKDF2, bcrypt, or Argon2, ensuring that even if the hashed password is exposed, it cannot be easily reversed.
- **Password Validation**: Passwords are validated on the server to meet strength requirements (e.g., minimum length, complexity) to reduce the risk of weak passwords.

By using industry-standard encryption and security practices, we aim to keep your account and data safe.

### Upcoming Feature: Signup via the App

In the near future, you will also be able to create an account directly through the Aquaware mobile app, making it even easier to get started.

---

If you have any issues or need help, feel free to contact our support team.
