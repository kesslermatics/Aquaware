import csv
from datetime import timedelta

from django.db.models import OuterRef, Subquery, Count, Max
from django.http import HttpResponse
from django.utils import timezone
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
def add_water_values(request, aquarium_id):
    try:
        aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'},
                        status=status.HTTP_404_NOT_FOUND)

    # Retrieve the most recent water value entry
    last_value = WaterValue.objects.filter(aquarium=aquarium).aggregate(last_measured_at=Max('measured_at'))
    last_measured_at = last_value['last_measured_at']

    # Check if the last measured time is within the last 30 minutes
    if last_measured_at and last_measured_at >= timezone.now() - timedelta(minutes=29):
        return Response(
            {'error': 'You can only submit water values once every 30 minutes.'},
            status=status.HTTP_429_TOO_MANY_REQUESTS
        )

    # Proceed to save the new water values if valid
    data = request.data.copy()
    data['aquarium_id'] = aquarium_id  # Füge die aquarium_id zu den Daten hinzu
    serializer = FlexibleWaterValuesSerializer(data=data)
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


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def export_water_values(request, aquarium_id):
    try:
        # Check if the aquarium exists and belongs to the logged-in user
        try:
            aquarium = Aquarium.objects.get(id=aquarium_id, user=request.user)
        except Aquarium.DoesNotExist:
            return Response({'error': 'Aquarium not found or does not belong to this user.'},
                            status=status.HTTP_404_NOT_FOUND)

        # Get the water values for the specified aquarium, ordered by measured_at
        water_values = WaterValue.objects.filter(aquarium=aquarium).select_related('parameter').order_by('measured_at')

        if not water_values.exists():
            return Response({'error': 'No water values found for this aquarium.'}, status=status.HTTP_404_NOT_FOUND)

        # Prepare the HttpResponse with the appropriate content type
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = f'attachment; filename="water_values_{aquarium_id}.csv"'

        writer = csv.writer(response)

        # Get distinct parameter names to dynamically generate the columns
        parameters = list(WaterValue.objects.filter(aquarium=aquarium)
                         .values_list('parameter__name', flat=True).distinct())
        parameters.sort()  # Sort parameter names to maintain consistent column order

        # Write the header row
        header = ['Measured At'] + parameters + [f"{param}_unit" for param in parameters]
        writer.writerow(header)

        # Group water values by 'measured_at'
        measurements = {}
        for value in water_values:
            measured_at = timezone.localtime(value.measured_at).strftime('%Y-%m-%d %H:%M:%S')
            if measured_at not in measurements:
                measurements[measured_at] = {param: '' for param in parameters}  # Initialize with empty values
                measurements[measured_at]['units'] = {param: '' for param in parameters}
            measurements[measured_at][value.parameter.name] = value.value
            measurements[measured_at]['units'][value.parameter.name] = value.parameter.unit

        # Write the data rows
        for measured_at, values in measurements.items():
            row = [measured_at]
            for param in parameters:
                row.append(values.get(param, ''))  # Add the value
            for param in parameters:
                row.append(values['units'].get(param, ''))  # Add the unit
            writer.writerow(row)

        return response

    except Exception as e:
        return Response({'error': f'An error occurred during export: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)