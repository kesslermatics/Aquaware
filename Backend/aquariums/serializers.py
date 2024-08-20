from rest_framework import serializers
from .models import Aquarium


class AquariumSerializer(serializers.ModelSerializer):
    name = serializers.CharField(required=True)
    description = serializers.CharField(required=True)
    
    class Meta:
        model = Aquarium
        fields = ['id', 'name', 'description', 'created_at']
        read_only_fields = ['id', 'created_at']
