# Aquaware Backend

The Aquaware Backend is the core of the Aquaware ecosystem, providing a robust API that powers the mobile app and enables users to monitor and manage their aquariums effectively. The backend is built with Django and Django REST Framework (DRF), ensuring scalability, security, and ease of use.

## Overview

The backend handles all data processing and storage related to water parameters, user settings, and historical data. It is responsible for authenticating users, storing aquarium-related data, and providing API endpoints for both the app and external integrations.

## API Documentation

The Aquaware API offers a comprehensive set of endpoints that allow you to interact with the system programmatically. Whether you're building integrations or using the API directly, the documentation will guide you through each endpoint's purpose and usage.

### Accessing the API Documentation

The API documentation is accessible through the Swagger interface, which provides an interactive and user-friendly way to explore and test the available endpoints.

- **Swagger UI**: You can access the API documentation by navigating to [/docs/](https://aquaware.kesslermatics.com/docs/). This interface allows you to see all available endpoints, their parameters, and expected responses. you can directly test the API endpoints within the Swagger UI, making it easy to understand how each part of the API works.

## API Lifecycle and Best Practices

To interact effectively with the Aquaware API, it’s important to follow a structured lifecycle process, especially when working with embedded systems like Arduino for automated data uploads. Below is a recommended approach to ensure smooth and secure communication with the Aquaware backend.

### 1. User Authentication

Before performing any actions on the API, you must first authenticate using your email and password. This step is crucial as it provides you with the necessary access and refresh tokens. These tokens are your gateway to the API, allowing you to securely add data and retrieve information related to your aquarium.

**Example:** When using an Arduino to automate data uploads, you should initiate the authentication process as soon as the device powers on or connects to the network. This will provide you with a set of tokens needed for subsequent API calls.

### 2. Token Management

The access token obtained during authentication is short-lived and needs to be refreshed periodically. Before every data upload, you should request a new access token using the refresh token. This ensures that your connection remains secure and that you can continue interacting with the API without interruption.

**Example:** For automated systems like Arduino, it is recommended to always check the validity of the access token before making any API requests. If the token is expired, use the refresh token to obtain a new one before proceeding with data uploads.

### 3. Data Upload Rate Limitation

To optimize server resources and ensure fair usage among all users, Aquaware enforces a rate limitation on data uploads. Specifically, you can only upload new water parameter values once every 30 minutes. This limitation helps maintain the integrity of the data and prevents unnecessary server load.

**Example:** When configuring your Arduino or any other automated system, implement a timer or delay mechanism that ensures data uploads occur no more frequently than every 30 minutes. If you attempt to upload data more frequently, the API will return an error, and the data will not be accepted.

By following this lifecycle approach, you can ensure that your interactions with the Aquaware API are efficient, secure, and in compliance with usage policies.


## Key API Endpoints

The Aquaware API is designed to be both comprehensive and easy to use, providing all the necessary functionality to manage aquariums, monitor water parameters, and handle user authentication. Below are some of the most critical endpoints that you will frequently interact with:

### 1. User Authentication

User authentication is the first step to interacting with the Aquaware API. This process ensures that only authorized users can access and modify their aquarium data.

- **Register**: This endpoint allows new users to sign up for Aquaware. The user needs to provide their email, password, and other relevant details. This can also be done in the app.
- **Login**: Once registered, users can log in using their email and password. This endpoint returns a pair of JWT tokens (access and refresh), which are required for subsequent API requests.
- **Token Refresh**: The access token is short-lived, so users must periodically refresh their token using the refresh token to maintain their session.

#### Example: Login

```bash
curl -X POST https://aquaware-production.up.railway.app/api/users/login/ \
-H "Content-Type: application/json" \
-d '{
  "email": "user@example.com",
  "password": "yourpassword"
}'
```

This request will return a response containing the access and refresh tokens:

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
curl -X POST https://aquaware-production.up.railway.app/api/users/token/refresh/ \
-H "Content-Type: application/json" \
-d '{
  "refresh": "your-refresh-token"
}'
```

This request will return a respones containing the access token:

```json
{
  "access": "your-new-access-token"
}
```

### 2. Water Parameters

Water parameter management is at the heart of the Aquaware API, enabling users to log and retrieve critical data points such as temperature, pH, and oxygen levels (see the full list of available parameters at [the Doc under adding of measurements](https://aquaware.kesslermatics.com/docs/).

#### Example: Add Measurement

```bash
curl -X POST https://aquaware-production.up.railway.app/api/measurements/add/3/ \
-H "Content-Type: application/json" \
-H "Authorization: Bearer your-access-token" \
-d '{
  "Temperature": 26.9,
  "PH": 8.2,
  "Oxygen": 8.9,
  "TDS": 630
}'
```

This request will log the water parameters for the specified aquarium (in this case, aquarium ID 3). The response will confirm the successful addition of the data.

