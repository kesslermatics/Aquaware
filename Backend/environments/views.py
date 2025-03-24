from django.db import IntegrityError
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Environment, UserEnvironmentSubscription
from .serializers import EnvironmentSerializer
from users.authentication import APIKeyAuthentication
import paho.mqtt.client as mqtt

@api_view(['GET', 'POST'])
@authentication_classes([APIKeyAuthentication])
def environment_views(request):
    if request.method == 'GET':
        return get_user_environments(request)
    if request.method == 'POST':
        return create_environment(request)


@api_view(['GET', 'PUT', 'DELETE'])
@authentication_classes([APIKeyAuthentication])
def environment_id_views(request, id):
    if request.method == 'GET':
        return get_environment(request, id)
    elif request.method == 'PUT':
        return update_environment(request, id)
    elif request.method == 'DELETE':
        return delete_environment(request, id)


def create_environment(request):
    try:
        serializer = EnvironmentSerializer(data=request.data)
        if serializer.is_valid():
            environment = serializer.save(user=request.user)
            publish_reset_topic(environment.id, request.user.api_key)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(f"Error in create_environment view: {e}")
        return Response({'detail': 'Internal Server Error'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def publish_reset_topic(env_id, api_key):
    topic = f"env/{env_id}/reset"
    payload = "ready"

    client = mqtt.Client(client_id=f"aquaware-env-{env_id}")
    client.username_pw_set(username=api_key, password="dummy")
    client.on_log = lambda c, u, l, s: print(f"[MQTT LOG] {s}")

    client.connect("emqx", 1883, 60)
    client.publish(topic, payload)
    client.disconnect()


def get_environment(request, id):
    try:
        environment = Environment.objects.get(id=id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = EnvironmentSerializer(environment)
    return Response(serializer.data)


def update_environment(request, id):
    try:
        environment = Environment.objects.get(id=id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = EnvironmentSerializer(environment, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def delete_environment(request, id):
    user = request.user

    try:
        # Check if the environment belongs to the user (ownership)
        environment = Environment.objects.get(id=id, user=user)
        # If the user is the owner, delete the environment
        environment.delete()
        return Response({'message': 'Environment deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)

    except Environment.DoesNotExist:
        try:
            # If the user does not own the environment, check if the user is subscribed to it
            subscription = UserEnvironmentSubscription.objects.get(environment_id=id, user=user)
            # Delete the subscription but keep the environment
            subscription.delete()
            return Response({'message': 'Subscription removed successfully.'}, status=status.HTTP_204_NO_CONTENT)

        except UserEnvironmentSubscription.DoesNotExist:
            return Response({'error': 'Environment not found or no subscription exists for this user.'},
                            status=status.HTTP_404_NOT_FOUND)

    except Exception as e:
        return Response({'error': f'An error occurred: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@authentication_classes([APIKeyAuthentication])
def get_public_environments(request):
    public_environments = Environment.objects.filter(public=True).exclude(user=request.user)
    serializer = EnvironmentSerializer(public_environments, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['POST'])
def subscribe_to_environment(request, environment_id):
    user = request.user
    try:
        environment = Environment.objects.get(id=environment_id, public=True)
        UserEnvironmentSubscription.objects.create(user=user, environment=environment )
        return Response({'message': 'Subscribed successfully'}, status=status.HTTP_201_CREATED)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or not public'}, status=status.HTTP_404_NOT_FOUND)
    except IntegrityError:
        return Response({'error': 'Already subscribed'}, status=status.HTTP_400_BAD_REQUEST)


def get_user_environments(request):
    user = request.user

    owned_environments = Environment.objects.filter(user=user)

    subscribed_environments = Environment.objects.filter(
        id__in=UserEnvironmentSubscription.objects.filter(user=user).values_list('environment_id', flat=True)
    )

    # Combine and serialize
    environments = owned_environments | subscribed_environments
    serializer = EnvironmentSerializer(environments, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@authentication_classes([APIKeyAuthentication])
def mark_environment_as_setup(request, environment_id):
    try:
        environment = Environment.objects.get(id=environment_id, user=request.user)

        environment.is_setup = True
        environment.save(update_fields=["is_setup"])

        return Response({"detail": "Environment marked as set up."}, status=status.HTTP_200_OK)

    except Environment.DoesNotExist:
        return Response({"error": "Environment not found or not owned by user."}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
@authentication_classes([APIKeyAuthentication])
def check_environment_setup(request, environment_id):
    try:
        environment = Environment.objects.get(id=environment_id, user=request.user)
        return Response({"is_setup": environment.is_setup}, status=status.HTTP_200_OK)

    except Environment.DoesNotExist:
        return Response({"error": "Environment not found or not owned by user."}, status=status.HTTP_404_NOT_FOUND)
