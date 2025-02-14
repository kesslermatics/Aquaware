import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)  # Create a test client for FastAPI

def test_register_user():
    """
    Tests the user signup endpoint with valid data.
    Expects a 201 response and an API key.
    """
    response = client.post("/api/users/auth/signup", json={
        "email": "testuser@example.com",
        "first_name": "Test",
        "last_name": "User",
        "password": "securepassword123"
    })
    
    assert response.status_code == 201
    json_response = response.json()
    
    assert "detail" in json_response
    assert json_response["detail"] == "User created successfully"
    assert "api_key" in json_response

def test_register_existing_email():
    """
    Tests that a user cannot register with an email that already exists.
    Expects a 409 Conflict response.
    """
    client.post("/api/users/auth/signup", json={
        "email": "duplicate@example.com",
        "first_name": "Test",
        "last_name": "User",
        "password": "securepassword123"
    })

    response = client.post("/api/users/auth/signup", json={
        "email": "duplicate@example.com",
        "first_name": "Test2",
        "last_name": "User2",
        "password": "anotherpassword456"
    })

    assert response.status_code == 409
    assert response.json()["detail"] == "Email already in use"

def test_register_invalid_email():
    """
    Tests that a user cannot register with an invalid email format.
    Expects a 422 Unprocessable Entity response.
    """
    response = client.post("/api/users/auth/signup", json={
        "email": "invalid-email",
        "first_name": "Test",
        "last_name": "User",
        "password": "securepassword123"
    })
    
    assert response.status_code == 422 

def test_register_missing_fields():
    """
    Tests that a user cannot register if required fields are missing.
    Expects a 422 Unprocessable Entity response.
    """
    response = client.post("/api/users/auth/signup", json={
        "email": "missingfields@example.com",
        "password": "securepassword123"
    })

    assert response.status_code == 422
