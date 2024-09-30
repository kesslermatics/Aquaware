from django.db import IntegrityError
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Environment, UserEnvironmentSubscription
from .serializers import EnvironmentSerializer


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_environment(request):
    try:
        serializer = EnvironmentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(f"Error in create_environment view: {e}")
        return Response({'detail': 'Internal Server Error'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_environment(request, id):
    try:
        environment = Environment.objects.get(id=id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = EnvironmentSerializer(environment)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_public_environments(request):
    public_environments = Environment.objects.filter(public=True).exclude(user=request.user)
    serializer = EnvironmentSerializer(public_environments, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
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



@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_environment(request, id):
    try:
        environment = Environment.objects.get(id=id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    environment.delete()
    return Response({'message': 'Environment deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


@api_view(['POST'])
def subscribe_to_environment(request, environment_id):
    user = request.user
    try:
        environment = Environment.objects.get(id=environment_id, public=True)
        UserEnvironmentSubscription.objects.create(user=user, environment=environment)
        return Response({'message': 'Subscribed successfully'}, status=status.HTTP_201_CREATED)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or not public'}, status=status.HTTP_404_NOT_FOUND)
    except IntegrityError:
        return Response({'error': 'Already subscribed'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
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
