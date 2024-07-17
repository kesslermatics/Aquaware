from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from aquariums.models import Aquarium
from .models import WaterParameter, WaterValue

User = get_user_model()


class WaterTests(APITestCase):

    def setUp(self):
        self.signup_url = reverse('user-signup')
        self.login_url = reverse('user-login')
        self.create_aquarium_url = reverse('create-aquarium')
        self.add_water_values_url = reverse('add-water-values')
        self.user_data = {
            "email": "newuser@example.com",
            "password": "newuserpassword",
            "password2": "newuserpassword",
            "first_name": "New",
            "last_name": "User"
        }
        self.aquarium_data = {
            'name': 'Test Aquarium',
            'description': 'This is a test aquarium'
        }
        self.client.post(self.signup_url, self.user_data)
        response = self.client.post(self.login_url, self.user_data)
        self.token = response.data['access']
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token)
        response = self.client.post(self.create_aquarium_url, self.aquarium_data)
        self.aquarium = Aquarium.objects.get(name=self.aquarium_data['name'])

        self.water_data = {
            'aquarium_id': self.aquarium.id,
            'temperature': 25.0,
            'pH': 7.5,
            'oxygen': 8.0,
            'tds': 300
        }

        WaterParameter.objects.create(name='temperature', unit='°C')
        WaterParameter.objects.create(name='pH', unit='pH')
        WaterParameter.objects.create(name='oxygen', unit='mg/L')
        WaterParameter.objects.create(name='tds', unit='ppm')

    def test_add_water_values(self):
        response = self.client.post(self.add_water_values_url, self.water_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(len(response.data), 4)

    def test_get_all_values(self):
        self.client.post(self.add_water_values_url, self.water_data)
        response = self.client.get(reverse('aquarium-water-values', args=[self.aquarium.id]))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(len(response.data) > 0)

    def test_get_all_values_from_parameter(self):
        self.client.post(self.add_water_values_url, self.water_data)
        response = self.client.get(reverse('aquarium-parameter-values', args=[self.aquarium.id, 'temperature']))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(len(response.data) > 0)
        self.assertIn('temperature', response.data[0])
