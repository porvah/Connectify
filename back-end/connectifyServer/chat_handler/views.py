from django.shortcuts import render
from .messageSerializer import MessageSerializer
from . messagemodels import Message
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response

# Create your views here.
@api_view(['GET'])
def GetMessages(request):
        message = Message.objects.all()
        serializer = MessageSerializer(message,many = True)
        return Response(serializer.data)