from rest_framework import serializers
from .models import Environment


class EnvironmentSerializer(serializers.ModelSerializer):
    name = serializers.CharField(required=True)
    description = serializers.CharField(required=True)
    environment_type = serializers.ChoiceField(choices=Environment.ENVIRONMENT_TYPES)
    public = serializers.BooleanField(default=False)
    city = serializers.CharField(required=False)

    class Meta:
        model = Environment
        fields = ['id', 'name', 'description', 'created_at', "environment_type", "public", "city"]
        read_only_fields = ['id', 'created_at']
