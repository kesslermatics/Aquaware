from datetime import timedelta

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from pathlib import Path
from .serializers import WaterParameterSerializer, WaterValueSerializer, FlexibleWaterValuesSerializer

from .models import WaterParameter, WaterValue
from aquariums.models import Aquarium

BASE_DIR = Path(__file__).resolve().parent.parent


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_water_values(request):
    # Extract the aquarium_id from the request data
    aquarium_id = request.data.get('aquarium_id')

    # Check if the aquarium_id is provided
    if not aquarium_id:
        return Response({'error': 'aquarium_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        # Check if the aquarium belongs to the authenticated user
        aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'},
                        status=status.HTTP_404_NOT_FOUND)

    # Proceed with adding water values if the aquarium belongs to the user
    serializer = FlexibleWaterValuesSerializer(data=request.data)
    if serializer.is_valid():
        water_values = serializer.save()
        response_serializer = WaterValueSerializer(water_values, many=True)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_values(request, aquarium_id):
    try:
        # Filter water values by aquarium_id and ensure the aquarium belongs to the authenticated user
        water_values = WaterValue.objects.filter(aquarium_id=aquarium_id, aquarium__user=request.user).select_related(
            'parameter').order_by('measured_at')

        # If no water values are found, ensure we return an appropriate response
        if not water_values.exists():
            return Response({'detail': 'No water values found or aquarium does not belong to this user.'},
                            status=status.HTTP_404_NOT_FOUND)

        # Organize the water values by 2-minute intervals
        measurements = []
        current_bundle = None
        last_time = None

        for water_value in water_values:
            measured_at = water_value.measured_at.replace(second=0, microsecond=0)
            if last_time is None or measured_at - last_time > timedelta(minutes=2):
                current_bundle = {
                    'measured_at': measured_at.isoformat(),
                    water_value.parameter.name: {
                        'value': water_value.value,
                        'unit': water_value.parameter.unit
                    }
                }
                measurements.append(current_bundle)
                last_time = measured_at
            else:
                current_bundle[water_value.parameter.name] = {
                    'value': water_value.value,
                    'unit': water_value.parameter.unit
                }

        return Response(measurements, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_values_from_parameter(request, aquarium_id, parameter_name):
    try:
        # Überprüfe, ob der Parameter existiert
        parameter = WaterParameter.objects.get(name=parameter_name)

        # Filter Wasserwerte nach aquarium_id, parameter und sicherstellen, dass das Aquarium dem authentifizierten Benutzer gehört
        water_values = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            aquarium__user=request.user,
            parameter=parameter
        )

        # Falls keine Wasserwerte gefunden werden, eine entsprechende Antwort zurückgeben
        if not water_values.exists():
            return Response(
                {'detail': 'No water values found for this parameter or aquarium does not belong to this user.'},
                status=status.HTTP_404_NOT_FOUND)

        # Organisiere die Wasserwerte nach dem Messzeitpunkt
        measurements = []
        for water_value in water_values:
            measurements.append({
                'measured_at': water_value.measured_at,
                parameter.name: {
                    'value': water_value.value,
                    'unit': water_value.parameter.unit
                }
            })

        return Response(measurements, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)