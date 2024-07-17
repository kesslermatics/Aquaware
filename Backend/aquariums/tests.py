import uuid

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from .models import Aquarium

User = get_user_model()


class AquariumTests(APITestCase):

    def setUp(self):
        self.signup_url = reverse('user-signup')
        self.login_url = reverse('user-login')
        self.create_aquarium_url = reverse('create-aquarium')
        self.update_aquarium_url = lambda id: reverse('update-aquarium', args=[id])
        self.delete_aquarium_url = lambda id: reverse('delete-aquarium', args=[id])
        self.get_user_aquariums_url = reverse('get-user-aquariums')

        self.user_data = {
            "email": "newuser@example.com",
            "password": "newuserpassword",
            "password2": "newuserpassword",
            "first_name": "New",
            "last_name": "User"
        }
        self.aquarium_data = {
            'name': 'Test Aquarium' + str(uuid.uuid4()),
            'description': 'This is a test aquarium'
        }

        self.client.post(self.signup_url, self.user_data)
        response = self.client.post(self.login_url, self.user_data)
        self.token = response.data.get('access')
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token)

        response = self.client.post(self.create_aquarium_url, self.aquarium_data)
        self.aquarium_id = response.data.get('id')

    def test_create_aquarium(self):
        unique_name = 'Test Aquarium ' + str(uuid.uuid4())
        response = self.client.post(self.create_aquarium_url, {'name': unique_name, 'description': 'Another test aquarium'})
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['name'], unique_name)

    def test_update_aquarium(self):
        update_data = {'description': 'Updated description'}
        response = self.client.put(self.update_aquarium_url(self.aquarium_id), update_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['description'], 'Updated description')

    def test_delete_aquarium(self):
        response = self.client.delete(self.delete_aquarium_url(self.aquarium_id))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        response = self.client.get(self.delete_aquarium_url(self.aquarium_id))
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_get_user_aquariums(self):
        response = self.client.get(self.get_user_aquariums_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(len(response.data) > 0)
