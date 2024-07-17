from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from pathlib import Path
from .serializers import WaterParameterSerializer, WaterValueSerializer, FlexibleWaterValuesSerializer

from .models import WaterParameter

BASE_DIR = Path(__file__).resolve().parent.parent

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_water_values(request):
    serializer = FlexibleWaterValuesSerializer(data=request.data)
    if serializer.is_valid():
        water_values = serializer.save()
        response_serializer = WaterValueSerializer(water_values, many=True)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_water_values(request):
    all_entries = WaterParameter.objects.filter(user=request.user).order_by('-timestamp')
    serializer = WaterParameterSerializer(all_entries, many=True)
    return Response(serializer.data)
