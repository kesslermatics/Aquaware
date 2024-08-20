from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Aquarium
from .serializers import AquariumSerializer

@swagger_auto_schema(
    method='post',
    request_body=AquariumSerializer,
    responses={
        201: AquariumSerializer,
        400: 'Bad Request'
    }
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_aquarium(request):
    try:
        serializer = AquariumSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(f"Error in create_aquarium view: {e}")
        return Response({'detail': 'Internal Server Error'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@swagger_auto_schema(
    method='get',
    responses={
        200: AquariumSerializer,
        404: 'Not Found'
    },
    operation_description="Retrieve an aquarium by ID. The aquarium must belong to the authenticated user."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_aquarium(request, id):
    try:
        aquarium = Aquarium.objects.get(id=id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = AquariumSerializer(aquarium)
    return Response(serializer.data)


@swagger_auto_schema(
    method='get',
    responses={
        200: AquariumSerializer(many=True),
    },
    operation_description="Retrieve all aquariums belonging to the authenticated user."
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_aquariums(request):
    aquariums = Aquarium.objects.filter(user=request.user)
    serializer = AquariumSerializer(aquariums, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@swagger_auto_schema(
    method='put',
    request_body=AquariumSerializer,
    responses={
        200: AquariumSerializer,
        400: 'Bad Request',
        404: 'Not Found'
    },
    operation_description="Update an existing aquarium. The aquarium must belong to the authenticated user. Partial updates are allowed."
)
@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_aquarium(request, id):
    try:
        aquarium = Aquarium.objects.get(id=id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = AquariumSerializer(aquarium, data=request.data, partial=True)
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
    operation_description="Delete an existing aquarium. The aquarium must belong to the authenticated user."
)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_aquarium(request, id):
    try:
        aquarium = Aquarium.objects.get(id=id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    aquarium.delete()
    return Response({'message': 'Aquarium deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)
