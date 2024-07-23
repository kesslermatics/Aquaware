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

class FlexibleWaterValuesSerializer(serializers.Serializer):
    aquarium_id = serializers.IntegerField()
    temperature = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    pH = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    oxygen = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    tds = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)

    def create(self, validated_data):
        aquarium_id = validated_data.pop('aquarium_id')
        water_values = []
        for param_name, value in validated_data.items():
            print(validated_data)
            if value is not None:
                try:
                    parameter = WaterParameter.objects.get(name=param_name)
                except WaterParameter.DoesNotExist:
                    raise serializers.ValidationError(f"Parameter {param_name} does not exist")
                water_value = WaterValue.objects.create(
                    aquarium_id=aquarium_id,
                    parameter=parameter,
                    value=value
                )
                water_values.append(water_value)
        return water_values
