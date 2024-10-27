
# Aquaware Backend

The Aquaware Backend is the core of the Aquaware ecosystem, providing a robust API that powers the mobile app and enables users to monitor and manage their aquariums effectively. The backend is built with Django and Django REST Framework (DRF), ensuring scalability, security, and ease of use.

## Overview

The backend handles all data processing and storage related to water parameters, user settings, and historical data. It is responsible for authenticating users, storing aquarium-related data, and providing API endpoints for both the app and external integrations.

## API Documentation

The Aquaware API offers a comprehensive set of endpoints that allow you to interact with the system programmatically. Whether you're building integrations or using the API directly, the documentation will guide you through each endpoint's purpose and usage.

### Accessing the API Documentation

The API documentation is accessible and provides an interactive, user-friendly way to explore and test the available endpoints.

- **API Documentation**: You can access the API documentation by navigating to [Aquaware Docs](https://aquaware.cloud/docs/index.html). This interface allows you to see all available endpoints, their parameters, and expected responses.

## API Lifecycle and Best Practices

To interact effectively with the Aquaware API, it’s important to follow a structured lifecycle process, especially when working with embedded systems like Arduino for automated data uploads. Below is a recommended approach to ensure smooth and secure communication with the Aquaware backend.

### 1. User Authentication

Before performing any actions on the API, you must first authenticate using your email and password. This step is crucial as it provides you with the necessary access and refresh tokens. These tokens are your gateway to the API, allowing you to securely add data and retrieve information related to your aquarium.

**Example:** When using an Arduino to automate data uploads, initiate the authentication process as soon as the device powers on or connects to the network.

### 2. Token Management

The access token obtained during authentication is short-lived and needs to be refreshed periodically. Always request a new access token using the refresh token before every data upload to maintain a secure connection.

**Example:** For automated systems like Arduino, check the access token’s validity before making any API requests. If the token is expired, use the refresh token to obtain a new one before proceeding.

### 3. Data Upload Rate Limitation

To optimize server resources and ensure fair usage, Aquaware enforces a rate limitation on data uploads, allowing new uploads only every 2 hours for the basic plan and 30 minutes for other plans.

**Example:** Implement a timer or delay mechanism in your automated system to ensure data uploads occur no more frequently than every 30 minutes.

By following this lifecycle approach, you can ensure that your interactions with the Aquaware API are efficient, secure, and in compliance with usage policies.

## Key API Endpoints

The Aquaware API is comprehensive and user-friendly, enabling you to manage aquariums, monitor water parameters, and handle user authentication.

### 1. User Authentication

User authentication is the first step to interacting with the Aquaware API.

- **Register**: This endpoint allows new users to sign up for Aquaware by providing their email, password, and other relevant details.
- **Login**: Once registered, users can log in using their email and password. This endpoint returns a pair of JWT tokens (access and refresh), which are required for subsequent API requests.
- **Token Refresh**: The access token is short-lived, so users must periodically refresh their token using the refresh token.

#### Example: Login

```bash
curl -X POST https://dev.aquaware.cloud/api/users/login/ \
-H "Content-Type: application/json" \
-d '{
  "email": "user@example.com",
  "password": "yourpassword"
}'
```

Response:

```json
{
  "refresh": "your-refresh-token",
  "access": "your-access-token",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "date_joined": "2024-08-23T18:25:43.511Z"
  }
}
```

#### Example: Get Access Token

```bash
curl -X POST https://dev.aquaware.cloud/api/users/token/refresh/ \
-H "Content-Type: application/json" \
-d '{
  "refresh": "your-refresh-token"
}'
```

Response:

```json
{
  "access": "your-new-access-token"
}
```

### 2. Water Parameters

Water parameter management is at the heart of the Aquaware API, enabling users to log and retrieve critical data points.

#### Example: Add Measurement

```bash
curl -X POST https://dev.aquaware.cloud/api/measurements/add/3/ \
-H "Content-Type: application/json" \
-H "Authorization: Bearer your-access-token" \
-d '{
  "Temperature": 26.9,
  "PH": 8.2,
  "Oxygen": 8.9,
  "TDS": 630
}'
```

Response:

```json
{
  "success": "Measurement added successfully"
}
```


## Licensing

Aquaware is licensed for non-commercial use only. You may not use Aquaware’s code, data, or services for commercial purposes. For licensing inquiries, please contact the Aquaware team directly.
