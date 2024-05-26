from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from pathlib import Path

from ..models import WaterParameter

BASE_DIR = Path(__file__).resolve().parent.parent
from ..serializers import WaterParameterSerializer


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_entry(request):
    user = request.user
    serializer = WaterParameterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=user)
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_entries(request):
    all_entries = WaterParameter.objects.filter(user=request.user).order_by('-timestamp')
    serializer = WaterParameterSerializer(all_entries, many=True)
    return Response(serializer.data)

