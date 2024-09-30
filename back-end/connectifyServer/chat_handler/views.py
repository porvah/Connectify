from django.shortcuts import render
from .messageSerializer import MessageSerializer
from . messagemodels import Message
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
import json
# Create your views here.

@api_view(['GET'])
def GetMessages(request):
    messages = Message.objects.all()
    packets = [{"packet": message.packet} for message in messages]
    for item in packets:
        item ['packet'] = json.loads(item['packet'])
    data = [item['packet'] for item in packets]
    return Response(data)
