from rest_framework import serializers
from .models import Environment


class EnvironmentSerializer(serializers.ModelSerializer):
    name = serializers.CharField(required=True)
    description = serializers.CharField(required=True)

    class Meta:
        model = Environment
        fields = ['id', 'name', 'description', 'created_at', "public"]
        read_only_fields = ['id', 'created_at']
