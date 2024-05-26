from rest_framework import serializers
from django.contrib.auth.models import User

from .models import WaterParameter


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')


class WaterParameterSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaterParameter
        fields = ['ph', 'temperature', 'co2', "tds"]
        read_only_fields = ['id', 'timestamp', 'user']
