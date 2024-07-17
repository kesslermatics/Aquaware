from rest_framework import serializers
from .models import WaterParameter, WaterValue

class WaterParameterSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaterParameter
        fields = ['id', 'name', 'unit']
        read_only_fields = ['id']

class WaterValueSerializer(serializers.ModelSerializer):
    parameter = WaterParameterSerializer()

    class Meta:
        model = WaterValue
        fields = ['id', 'aquarium', 'parameter', 'value', 'measured_at']
        read_only_fields = ['id', 'measured_at', 'aquarium']

    def create(self, validated_data):
        parameter_data = validated_data.pop('parameter')
        parameter, created = WaterParameter.objects.get_or_create(**parameter_data)
        water_value = WaterValue.objects.create(parameter=parameter, **validated_data)
        return water_value
