import csv
import io
from collections import defaultdict
from datetime import timedelta, datetime

from django.core.exceptions import ObjectDoesNotExist
from django.core.mail import send_mail
from django.db.models import OuterRef, Subquery, Count, Max
from django.http import HttpResponse
from django.template.loader import render_to_string
from django.utils import timezone
from django.utils.dateparse import parse_datetime
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from requests.compat import chardet
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, parser_classes
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from pathlib import Path

from aquaware import settings
from .serializers import WaterParameterSerializer, WaterValueSerializer, FlexibleWaterValuesSerializer, \
    UserAlertSettingSerializer

from .models import WaterParameter, WaterValue, UserAlertSetting
from environments.models import Environment

BASE_DIR = Path(__file__).resolve().parent.parent


@swagger_auto_schema(
    method='post',
    request_body=FlexibleWaterValuesSerializer,
    responses={
        201: openapi.Response('Created', WaterValueSerializer(many=True)),
        400: 'Bad Request',
        404: 'Not Found',
        429: 'Too Many Requests'
    },
    operation_description="Add water values to an environment. Ensures values are only added once every 30 minutes."
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_water_values(request, environment_id):
    try:
        environment = Environment.objects.get(id=environment_id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'},
                        status=status.HTTP_404_NOT_FOUND)

        # Fetch the user's subscription tier upload frequency
    user_subscription_tier = request.user.subscription_tier
    if not user_subscription_tier:
        return Response({'error': 'User does not have a valid subscription tier.'},
                            status=status.HTTP_400_BAD_REQUEST)

        # Use the upload frequency from the user's subscription tier
    upload_frequency_minutes = user_subscription_tier.upload_frequency_minutes

    last_value = WaterValue.objects.filter(environment=environment).aggregate(last_measured_at=Max('added_at'))
    last_measured_at = last_value['last_measured_at']

    print(timezone.now() - timedelta(upload_frequency_minutes - 1))

    if last_measured_at and last_measured_at >= timezone.now() - timedelta(minutes=(upload_frequency_minutes - 1)):
        return Response(
            {'error': 'You can only submit water values once every ' + str(upload_frequency_minutes) + ' minutes.'},
            status=status.HTTP_429_TOO_MANY_REQUESTS
        )

    data = request.data.copy()
    data['environment_id'] = environment_id
    serializer = FlexibleWaterValuesSerializer(data=data)
    if serializer.is_valid():
        water_values = serializer.save()
        check_alerts_and_notify(water_values)
        response_serializer = WaterValueSerializer(water_values, many=True)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def check_alerts_and_notify(water_values):
    for water_value in water_values:
        alert_settings = UserAlertSetting.objects.filter(
            environment=water_value.environment,
            parameter=water_value.parameter
        )

        for setting in alert_settings:
            if setting.under_value is not None and water_value.value < setting.under_value:
                send_alert_email(
                    setting.user,
                    water_value.environment,
                    water_value.parameter.name,
                    water_value.value,
                    'below',
                    setting.under_value
                )

            if setting.above_value is not None and water_value.value > setting.above_value:
                send_alert_email(
                    setting.user,
                    water_value.environment,
                    water_value.parameter.name,
                    water_value.value,
                    'above',
                    setting.above_value
                )


def send_alert_email(user, environment, parameter_name, current_value, threshold_type, threshold_value):
    mail_subject = f'Alert: {parameter_name} has gone {threshold_type} threshold in your environment'

    message = render_to_string('alert/alert_email.html', {
        'user': user,
        'parameter_name': parameter_name,
        'environment_name': environment.name,
        'current_value': current_value,
        'threshold_type': threshold_type,
        'threshold_value': threshold_value,
    })

    send_mail(
        mail_subject,
        message,
        settings.DEFAULT_FROM_EMAIL,
        [user.email],
        html_message=message
    )


@swagger_auto_schema(
    method='get',
    manual_parameters=[
        openapi.Parameter('number_of_entries', openapi.IN_QUERY, description="Number of latest entries", type=openapi.TYPE_INTEGER)
    ],
    responses={
        200: openapi.Response('Success', openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=openapi.Schema(
                type=openapi.TYPE_OBJECT,
                properties={
                    'parameter': openapi.Schema(type=openapi.TYPE_STRING),
                    'values': openapi.Schema(type=openapi.TYPE_ARRAY, items=openapi.Schema(
                        type=openapi.TYPE_OBJECT,
                        properties={
                            'measured_at': openapi.Schema(type=openapi.TYPE_STRING, format='date-time'),
                            'value': openapi.Schema(type=openapi.TYPE_NUMBER),
                            'unit': openapi.Schema(type=openapi.TYPE_STRING),
                        }
                    )),
                }
            )
        )),
        400: 'Bad Request'
    },
    operation_description="Get the latest water values for all parameters in an environment."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_latest_from_all_parameters(request, environment_id, number_of_entries):
    try:
        environment = Environment.objects.get(id=environment_id, user=request.user)

        subquery = WaterValue.objects.filter(
            environment_id=environment_id,
            parameter_id=OuterRef('parameter_id')
        ).order_by('-measured_at')[:number_of_entries]

        water_values = WaterValue.objects.filter(
            environment_id=environment_id,
            environment__user=request.user,
            id__in=Subquery(subquery.values('id'))
        ).select_related('parameter').order_by('parameter_id', '-measured_at')

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
    except Environment.DoesNotExist:
        return Response({'detail': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@swagger_auto_schema(
    method='get',
    manual_parameters=[
        openapi.Parameter('parameter_name', openapi.IN_PATH, description="Name of the parameter", type=openapi.TYPE_STRING),
        openapi.Parameter('number_of_entries', openapi.IN_QUERY, description="Number of latest entries", type=openapi.TYPE_INTEGER)
    ],
    responses={
        200: openapi.Response('Success', openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=openapi.Schema(
                type=openapi.TYPE_OBJECT,
                properties={
                    'measured_at': openapi.Schema(type=openapi.TYPE_STRING, format='date-time'),
                    'value': openapi.Schema(type=openapi.TYPE_NUMBER),
                    'unit': openapi.Schema(type=openapi.TYPE_STRING),
                }
            )
        )),
        400: 'Bad Request'
    },
    operation_description="Get all water values for a specific parameter in an environment."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_values_from_parameter(request, environment_id, parameter_name, number_of_entries):
    try:
        parameter = WaterParameter.objects.get(name=parameter_name)
        water_values = WaterValue.objects.filter(
            environment_id=environment_id,
            environment__user=request.user,
            parameter=parameter
        ).order_by('-measured_at')[:number_of_entries]

        measurements = [{'measured_at': water_value.measured_at.isoformat(), 'value': water_value.value, 'unit': water_value.parameter.unit} for water_value in water_values]

        return Response(measurements, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@swagger_auto_schema(
    method='get',
    manual_parameters=[
        openapi.Parameter('parameter_name', openapi.IN_PATH, description="Name of the parameter", type=openapi.TYPE_STRING),
    ],
    responses={
        200: openapi.Response('Success', openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'total_entries': openapi.Schema(type=openapi.TYPE_INTEGER),
            }
        )),
        404: 'Not Found',
        400: 'Bad Request'
    },
    operation_description="Get the total number of entries for a specific parameter in an environment."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_total_entries(request, environment_id, parameter_name):
    try:
        parameter = WaterParameter.objects.get(name=parameter_name)
        total_entries = WaterValue.objects.filter(
            environment_id=environment_id,
            environment__user=request.user,
            parameter=parameter
        ).count()

        return Response({'total_entries': total_entries}, status=status.HTTP_200_OK)
    except WaterParameter.DoesNotExist:
        return Response({'detail': 'Parameter does not exist.'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'detail': 'An error occurred: {}'.format(str(e))}, status=status.HTTP_400_BAD_REQUEST)


@swagger_auto_schema(
    method='get',
    responses={
        200: 'CSV File',
        404: 'Not Found',
        400: 'Bad Request'
    },
    operation_description="Export water values as a CSV file for a specific environment."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def export_water_values(request, environment_id):
    try:
        # Check if the environment exists and belongs to the logged-in user
        try:
            environment = Environment.objects.get(id=environment_id, user=request.user)
        except Environment.DoesNotExist:
            return Response({'error': 'Environment not found or does not belong to this user.'},
                            status=status.HTTP_404_NOT_FOUND)

        # Get the water values for the specified environment, ordered by measured_at
        water_values = WaterValue.objects.filter(environment=environment).select_related('parameter').order_by('measured_at')

        if not water_values.exists():
            return Response({'error': 'No water values found for this environment.'}, status=status.HTTP_404_NOT_FOUND)

        # Use StringIO to write the CSV content in-memory
        output = io.StringIO()
        writer = csv.writer(output)

        # Get distinct parameter names to dynamically generate the columns
        parameters = list(WaterValue.objects.filter(environment=environment)
                         .values_list('parameter__name', flat=True).distinct())
        parameters.sort()  # Sort parameter names to maintain consistent column order

        # Write the header row
        header = ['Measured At'] + parameters + [f"{param}_unit" for param in parameters]
        writer.writerow(header)

        # Group water values by 5-minute intervals
        measurements = defaultdict(lambda: {param: [] for param in parameters})
        for value in water_values:
            # Round the measured_at time to the nearest 5 minutes
            measured_at = timezone.localtime(value.measured_at)
            rounded_time = measured_at - timedelta(minutes=measured_at.minute % 5, seconds=measured_at.second, microseconds=measured_at.microsecond)
            rounded_time_str = rounded_time.strftime('%Y-%m-%d %H:%M:%S')

            # Append the value to the corresponding parameter list for that time interval
            measurements[rounded_time_str][value.parameter.name].append(value.value)
            measurements[rounded_time_str][f"{value.parameter.name}_unit"] = value.parameter.unit

        # Calculate averages for each 5-minute interval and write to CSV
        for rounded_time, values in measurements.items():
            row = [rounded_time]
            for param in parameters:
                if values[param]:
                    # Calculate the average value for this parameter in the 5-minute window
                    avg_value = sum(values[param]) / len(values[param])
                    row.append(avg_value)
                else:
                    row.append('')
            for param in parameters:
                row.append(values[f"{param}_unit"])
            writer.writerow(row)

        # Ensure UTF-8 encoding by encoding the StringIO content
        response = HttpResponse(output.getvalue().encode('utf-8'), content_type='text/csv')
        response['Content-Disposition'] = f'attachment; filename="water_values_{environment_id}.csv"'

        return response

    except Exception as e:
        return Response({'error': f'An error occurred during export: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@swagger_auto_schema(
    method='post',
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'file': openapi.Schema(type=openapi.TYPE_STRING, format=openapi.FORMAT_BINARY, description="CSV file containing water values"),
        },
        required=['file']
    ),
    responses={
        201: 'Import Successful',
        400: 'Bad Request',
        429: 'Too Many Requests'
    },
    operation_description="Import water values from a CSV file. Ensures values are only added once every 30 minutes."
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def import_water_values(request, environment_id):
    try:
        # Ensure the environment exists and belongs to the user
        environment = Environment.objects.get(id=environment_id, user=request.user)

        # Fetch the user's subscription tier upload frequency
        user_subscription_tier = request.user.subscription_tier
        if not user_subscription_tier:
            return Response({'error': 'User does not have a valid subscription tier.'},
                            status=status.HTTP_400_BAD_REQUEST)

        # Use the upload frequency from the user's subscription tier
        upload_frequency_minutes = user_subscription_tier.upload_frequency_minutes

        # Retrieve the most recent water value entry
        last_value = WaterValue.objects.filter(environment=environment).aggregate(last_measured_at=Max('added_at'))
        last_measured_at = last_value['last_measured_at']

        # Check if the last measured time is within the last 30 minutes
        if last_measured_at and last_measured_at >= timezone.now() - timedelta(upload_frequency_minutes - 1):
            return Response(
                {'error': 'You can only submit water values once every ' + str(upload_frequency_minutes) + ' minutes.'},
                status=status.HTTP_429_TOO_MANY_REQUESTS
            )

        # Get the uploaded file
        csv_file = request.FILES['file']

        # Detect the encoding of the file
        raw_data = csv_file.read()
        result = chardet.detect(raw_data)
        encoding = result['encoding']
        csv_file.seek(0)  # Reset the file pointer to the beginning

        # Convert the file to a text stream with the detected encoding
        csv_file = io.TextIOWrapper(csv_file.file, encoding=encoding)

        # Create a CSV reader
        reader = csv.DictReader(csv_file)

        headers = reader.fieldnames

        # Ensure that the Measured At column exists
        if 'Measured At' not in headers:
            return Response({'error': 'Measured At column is required in the CSV file.'},
                            status=status.HTTP_400_BAD_REQUEST)

        # Filter out 'unit' columns from the headers
        parameters = [header for header in headers if not header.endswith('_unit') and header != 'Measured At']

        # Iterate over each row in the CSV file
        for row in reader:
            measured_at = parse_datetime(row['Measured At'])

            # Iterate over each parameter in the CSV file
            for parameter_name in parameters:
                value = row[parameter_name]
                unit = row.get(f'{parameter_name}_unit', '')

                # Fetch or create the WaterParameter
                parameter, _ = WaterParameter.objects.get_or_create(
                    name=parameter_name,
                    defaults={'unit': unit}
                )

                # Create the WaterValue entry
                WaterValue.objects.create(
                    environment=environment,
                    parameter=parameter,
                    value=value,
                    measured_at=measured_at,
                )

        return Response({'status': 'Import successful'}, status=status.HTTP_201_CREATED)

    except Exception as e:
        return Response({'error': f"An error occurred during import: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)


@swagger_auto_schema(
    method='post',
    request_body=UserAlertSettingSerializer,
    responses={
        200: 'Alert settings saved successfully',
        400: 'Bad Request',
        404: 'Not Found'
    },
    operation_description="Save alert settings for a specific parameter in an environment."
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_alert_settings(request, environment_id):
    try:
        user = request.user
        environment = Environment.objects.get(id=environment_id, user=user)

        serializer = UserAlertSettingSerializer(data=request.data)
        if serializer.is_valid():
            parameter = serializer.validated_data['parameter']
            under_value = serializer.validated_data.get('under_value')
            above_value = serializer.validated_data.get('above_value')

            # Update or create the alert setting
            alert_setting, created = UserAlertSetting.objects.update_or_create(
                user=user,
                environment=environment,
                parameter=parameter,
                defaults={
                    'under_value': under_value,
                    'above_value': above_value,
                }
            )

            return Response({'status': 'Alert settings saved successfully.'}, status=200)
        else:
            return Response(serializer.errors, status=400)

    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=404)
    except Exception as e:
        return Response({'error': f'An error occurred: {str(e)}'}, status=400)


@swagger_auto_schema(
    method='get',
    manual_parameters=[
        openapi.Parameter('parameter_name', openapi.IN_PATH, description="Name of the parameter", type=openapi.TYPE_STRING),
    ],
    responses={
        200: UserAlertSettingSerializer,
        404: 'Not Found',
        400: 'Bad Request'
    },
    operation_description="Get alert settings for a specific parameter in an environment."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_alert_settings(request, environment_id, parameter_name):
    try:
        user = request.user
        environment = Environment.objects.get(id=environment_id, user=user)
        parameter = WaterParameter.objects.get(name=parameter_name)

        alert_settings = UserAlertSetting.objects.filter(
            user=user, environment=environment, parameter=parameter
        ).first()

        if alert_settings:
            serializer = UserAlertSettingSerializer(alert_settings)
            return Response(serializer.data, status=200)
        else:
            return Response({'status': 'No alert settings found for this parameter.'}, status=404)

    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=404)
    except WaterParameter.DoesNotExist:
        return Response({'error': 'Parameter not found.'}, status=404)
    except Exception as e:
        return Response({'error': f'An error occurred: {str(e)}'}, status=400)

