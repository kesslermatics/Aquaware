from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Aquarium
from .serializers import AquariumSerializer

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

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_aquarium(request, id):
    try:
        aquarium = Aquarium.objects.get(id=id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    serializer = AquariumSerializer(aquarium)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_aquariums(request):
    aquariums = Aquarium.objects.filter(user=request.user)
    serializer = AquariumSerializer(aquariums, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

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

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_aquarium(request, id):
    try:
        aquarium = Aquarium.objects.get(id=id, user=request.user)
    except Aquarium.DoesNotExist:
        return Response({'error': 'Aquarium not found or does not belong to this user.'}, status=status.HTTP_404_NOT_FOUND)

    aquarium.delete()
    return Response({'message': 'Aquarium deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)