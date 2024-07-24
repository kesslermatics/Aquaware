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

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        parameters = WaterParameter.objects.all()
        self.valid_param_names = [parameter.name for parameter in parameters]
        for parameter in parameters:
            self.fields[parameter.name] = serializers.DecimalField(max_digits=10, decimal_places=3, required=False)

    def to_internal_value(self, data):
        # This method is called before validate and allows us to catch any unexpected parameters
        unexpected_params = [key for key in data.keys() if key not in self.fields and key != 'aquarium_id']
        if unexpected_params:
            raise serializers.ValidationError({param: 'Parameter not found in list' for param in unexpected_params})
        return super().to_internal_value(data)

    def create(self, validated_data):
        aquarium_id = validated_data.pop('aquarium_id')
        water_values = []
        for param_name, value in validated_data.items():
            if value is not None:
                parameter = WaterParameter.objects.get(name=param_name)
                water_value = WaterValue.objects.create(
                    aquarium_id=aquarium_id,
                    parameter=parameter,
                    value=value
                )
                water_values.append(water_value)
        return water_values
