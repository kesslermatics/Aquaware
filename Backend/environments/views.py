from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Environment
from .serializers import EnvironmentSerializer

@swagger_auto_schema(
    method='post',
    request_body=EnvironmentSerializer,
    responses={
        201: EnvironmentSerializer,
        400: 'Bad Request'
    }
)
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


@swagger_auto_schema(
    method='get',
    responses={
        200: EnvironmentSerializer,
        404: 'Not Found'
    },
    operation_description="Retrieve an environment by ID. The environment must belong to the authenticated user."
)
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


@swagger_auto_schema(
    method='get',
    responses={
        200: EnvironmentSerializer(many=True),
    },
    operation_description="Retrieve all environments belonging to the authenticated user."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_environments(request):
    environments = Environment.objects.filter(user=request.user)
    serializer = EnvironmentSerializer(environments, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@swagger_auto_schema(
    method='put',
    request_body=EnvironmentSerializer,
    responses={
        200: EnvironmentSerializer,
        400: 'Bad Request',
        404: 'Not Found'
    },
    operation_description="Update an existing environment. The environment must belong to the authenticated user. Partial updates are allowed."
)
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


@swagger_auto_schema(
    method='delete',
    responses={
        204: 'No Content',
        404: 'Not Found'
    },
    operation_description="Delete an existing environment. The environment must belong to the authenticated user."
)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_environment(request, id):
    try:
        environment = Environment.objects.get(id=id, user=request.user)
    except Environment.DoesNotExist:
        return Response({'error': 'Environment not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    environment.delete()
    return Response({'message': 'Environment deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)
