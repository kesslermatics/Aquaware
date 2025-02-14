import pytest
from fastapi.testclient import TestClient
from main import app
from app.modules.users.models import User
from app.modules.users.services import get_password_hash
from tests.conftest import TestingSessionLocal

client = TestClient(app)  # Use the test client from FastAPI

@pytest.fixture
def test_user():
    """
    Creates a test user in the test database.
    """
    user = User(
        email="testlogin@example.com",
        first_name="Test",
        last_name="Login",
        password=get_password_hash("securepassword123")
    )
    with TestingSessionLocal() as db:
        db.add(user)
        db.commit()
        db.refresh(user)
    return user

def test_successful_login(test_user):
    """
    Tests successful login with valid credentials.
    Expects a 202 response and API key in the response.
    """
    response = client.post("/api/users/auth/login", data={
        "username": test_user.email,
        "password": "securepassword123"
    })
    assert response.status_code == 200
    json_response = response.json()
    assert "api_key" in json_response
    assert json_response["user"]["email"] == test_user.email

def test_login_invalid_password(test_user):
    """
    Tests login with an invalid password.
    Expects a 400 response with an 'Invalid credentials' message.
    """
    response = client.post("/api/users/auth/login", data={
        "username": test_user.email,
        "password": "wrongpassword"
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "Invalid credentials"

def test_login_non_existent_user():
    """
    Tests login with a non-existent user.
    Expects a 400 response with an 'Invalid credentials' message.
    """
    response = client.post("/api/users/auth/login", data={
        "username": "nonexistent@example.com",
        "password": "somepassword"
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "Invalid credentials"
