from datetime import timedelta

from django.db.models import OuterRef, Subquery, Count
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
    aquarium_id = request.data.get('aquarium_id')
    if not aquarium_id:
        return Response({'error': 'aquarium_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = FlexibleWaterValuesSerializer(data=request.data)
    if serializer.is_valid():
        water_values = serializer.save()
        response_serializer = WaterValueSerializer(water_values, many=True)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_latest_from_all_parameters(request, aquarium_id, number_of_entries):
    try:
        aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)

        subquery = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            parameter_id=OuterRef('parameter_id')
        ).order_by('-measured_at')[:number_of_entries]

        water_values = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            aquarium__user=request.user,
            id__in=Subquery(subquery.values('id'))
        ).select_related('parameter').order_by('parameter_id', '-measured_at')

        if not water_values.exists():
            return Response({'detail': 'No water values found or aquarium does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

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

        response_data = [{'parameter': param, 'values': values} for param, values in measurements.items()]

        return Response(response_data, status=status.HTTP_200_OK)
    except Aquarium.DoesNotExist:
        return Response({'detail': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_values_from_parameter(request, aquarium_id, parameter_name, number_of_entries):
    try:
        parameter = WaterParameter.objects.get(name=parameter_name)
        water_values = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            aquarium__user=request.user,
            parameter=parameter
        ).order_by('-measured_at')[:number_of_entries]

        if not water_values.exists():
            return Response({'detail': 'No water values found for this parameter or aquarium does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

        measurements = [{'measured_at': water_value.measured_at.isoformat(), 'value': water_value.value, 'unit': water_value.parameter.unit} for water_value in water_values]

        return Response(measurements, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_total_entries(request, aquarium_id, parameter_name):
    try:
        parameter = WaterParameter.objects.get(name=parameter_name)
        total_entries = WaterValue.objects.filter(
            aquarium_id=aquarium_id,
            aquarium__user=request.user,
            parameter=parameter
        ).count()

        return Response({'total_entries': total_entries}, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)
