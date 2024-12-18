from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken

User = get_user_model()

class UsersEndpointsTestCase(APITestCase):

    def setUp(self):
        # Create a test user
        self.user = User.objects.create_user(
            email="testuser@example.com", password="testpassword123",
            first_name="Test", last_name="User"
        )
        self.user_id = self.user.id
        self.refresh = RefreshToken.for_user(self.user)
        self.access_token = str(self.refresh.access_token)

    # Authentication Tests
    def test_signup(self):
        url = reverse('auth-signup')
        data = {
            "email": "newuser@example.com",
            "password": "newpassword123",
            "first_name": "New",
            "last_name": "User"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_signup_existing_email(self):
        url = reverse('auth-signup')
        data = {
            "email": "testuser@example.com",
            "password": "testpassword123",
            "first_name": "Test",
            "last_name": "User"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertEqual(response.data['detail'], 'Email already in use')

    def test_login(self):
        url = reverse('auth-login')
        data = {
            "email": "testuser@example.com",
            "password": "testpassword123"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_login_invalid_credentials(self):
        url = reverse('auth-login')
        data = {
            "email": "testuser@example.com",
            "password": "wrongpassword"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['message'], 'Invalid credentials')

    def test_refresh_access_token(self):
        url = reverse('auth-token-refresh')
        data = {"refresh": str(self.refresh)}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)

    def test_refresh_invalid_token(self):
        url = reverse('auth-token-refresh')
        data = {"refresh": "invalidtoken"}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('error', response.data)

    # User Profile Tests
    def test_get_user_profile(self):
        url = reverse('user-detail', kwargs={'user_id': self.user_id})
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user.email)

    def test_update_user_profile(self):
        url = reverse('user-update', kwargs={'user_id': self.user_id})
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        data = {"first_name": "Updated"}
        response = self.client.put(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertEqual(self.user.first_name, "Updated")

    def test_delete_user_account(self):
        url = reverse('user-delete', kwargs={'user_id': self.user_id})
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(User.objects.filter(id=self.user_id).exists())

    # Password Management Tests
    def test_change_password(self):
        url = reverse('auth-password-change')
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        data = {
            "current_password": "testpassword123",
            "new_password": "newpassword123"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(self.user.check_password("newpassword123"))

    def test_change_password_invalid_current(self):
        url = reverse('auth-password-change')
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        data = {
            "current_password": "wrongpassword",
            "new_password": "newpassword123"
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['detail'], 'Current password is incorrect.')

    # Feedback Tests
    def test_send_feedback(self):
        url = reverse('feedback')
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        data = {
            "title": "Feedback Title",
            "message": "This is feedback content."
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['detail'], 'Feedback sent successfully.')

    def test_send_feedback_missing_fields(self):
        url = reverse('feedback')
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.access_token}')
        data = {"title": "Feedback Title"}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['error'], 'Title and message are required.')

    # Stripe Webhook Tests
    def test_stripe_webhook_invalid_payload(self):
        url = reverse('webhook-stripe')
        response = self.client.post(url, "InvalidPayload", content_type="application/json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['error'], 'Invalid payload')

    def test_stripe_webhook_signature_error(self):
        url = reverse('webhook-stripe')
        payload = {"type": "customer.subscription.created"}
        response = self.client.post(url, payload, content_type="application/json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['error'], 'Invalid signature')
