from rest_framework import status
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.authentication import SessionAuthentication, TokenAuthentication

from aquaware.models import WaterParameter
from aquaware.serializers import UserSerializer, WaterParameterSerializer
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404

@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_entry(request):
    user = request.user
    serializer = WaterParameterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=user)
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_all_entries(request):
    all_entries = WaterParameter.objects.filter(user=request.user).order_by('-timestamp')
    print(all_entries)
    serializer = WaterParameterSerializer(all_entries, many=True)
    return Response(serializer.data)