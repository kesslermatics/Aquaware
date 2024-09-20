from django.utils import timezone
from rest_framework import serializers
from .models import WaterParameter, WaterValue, UserAlertSetting


class WaterParameterSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaterParameter
        fields = ['id', 'name', 'unit']
        read_only_fields = ['id']

class WaterValueSerializer(serializers.ModelSerializer):
    parameter = WaterParameterSerializer()

    class Meta:
        model = WaterValue
        fields = ['id', 'environment', 'parameter', 'value', 'measured_at']
        read_only_fields = ['id', 'measured_at', 'environment']

class FlexibleWaterValuesSerializer(serializers.Serializer):
    environment_id = serializers.IntegerField()
    measured_at = serializers.DateTimeField(required=False)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        parameters = WaterParameter.objects.all()
        self.valid_param_names = [parameter.name for parameter in parameters]
        for parameter in parameters:
            self.fields[parameter.name] = serializers.DecimalField(max_digits=10, decimal_places=3, required=False)

    def to_internal_value(self, data):
        unexpected_params = [key for key in data.keys() if key not in self.fields and key != 'environment_id' and key != 'measured_at']
        if unexpected_params:
            raise serializers.ValidationError({param: 'Parameter not found in list' for param in unexpected_params})
        return super().to_internal_value(data)

    def create(self, validated_data):
        environment_id = validated_data.pop('environment_id')
        measured_at = validated_data.pop('measured_at', timezone.now())

        water_values = []
        for param_name, value in validated_data.items():
            if value is not None:
                parameter = WaterParameter.objects.get(name=param_name)
                water_value = WaterValue.objects.create(
                    environment_id=environment_id,
                    parameter=parameter,
                    value=value,
                    measured_at=measured_at
                )
                water_values.append(water_value)
        return water_values


class UserAlertSettingSerializer(serializers.ModelSerializer):
    parameter = serializers.SlugRelatedField(slug_field='name', queryset=WaterParameter.objects.all())
    user = serializers.PrimaryKeyRelatedField(read_only=True)
    environment = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = UserAlertSetting
        fields = ['user', 'environment', 'parameter', 'under_value', 'above_value']

