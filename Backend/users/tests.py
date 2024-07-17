from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model

User = get_user_model()


class UserTests(APITestCase):

    def setUp(self):
        self.signup_url = reverse('user-signup')
        self.login_url = reverse('user-login')
        self.user_data = {
            "email": "newuser@example.com",
            "password": "newuserpassword",
            "password2": "newuserpassword",
            "first_name": "New",
            "last_name": "User"
        }

    def test_user_signup(self):
        response = self.client.post(self.signup_url, self.user_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_user_login(self):
        self.client.post(self.signup_url, self.user_data)
        response = self.client.post(self.login_url, self.user_data)
        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)

    def test_get_user_profile(self):
        self.client.post(self.signup_url, self.user_data)
        response = self.client.post(self.login_url, self.user_data)
        token = response.data.get('access')
        self.assertIsNotNone(token)
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + token)
        response = self.client.get(reverse('user-profile'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user_data['email'])
