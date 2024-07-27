from datetime import timedelta

from django.db.models import OuterRef, Subquery
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
        print(response_serializer)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_latest_from_all_parameters(request, aquarium_id):
    try:
        # Verify that the aquarium belongs to the authenticated user
        aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)

        # Subquery to get the last 10 values per parameter
        subquery = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            parameter_id=OuterRef('parameter_id')
        ).order_by('-measured_at')[:10]

        # Fetch only the latest 10 values per parameter
        water_values = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            aquarium__user=request.user,
            id__in=Subquery(subquery.values('id'))
        ).select_related('parameter').order_by('parameter_id', '-measured_at')

        # If no water values are found, ensure we return an appropriate response
        if not water_values.exists():
            return Response({'detail': 'No water values found or aquarium does not belong to this user.'},
                            status=status.HTTP_404_NOT_FOUND)

        # Organize the water values by parameter
        measurements = {}
        for water_value in water_values:
            parameter_name = water_value.parameter.name
            if parameter_name not in measurements:
                measurements[parameter_name] = []
            measurements[parameter_name].append({
                'measured_at': water_value.measured_at.isoformat(),
                'value': water_value.value,
                'unit': water_value.parameter.unit
            })

        # Convert measurements dictionary to list for response
        response_data = [
            {'parameter': param, 'values': values}
            for param, values in measurements.items()
        ]

        return Response(response_data, status=status.HTTP_200_OK)
    except Aquarium.DoesNotExist:
        return Response({'detail': 'Aquarium not found or does not belong to this user.'},
                        status=status.HTTP_404_NOT_FOUND)
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
                'value': water_value.value,
                'unit': water_value.parameter.unit
            })

        return Response(measurements, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)