from django.shortcuts import render
from .messageSerializer import MessageSerializer
from . messagemodels import Message
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .NotificationsModel import Notification
from .NotificationsSerializer import NotificationSerializer 

# Create your views here.
@api_view(['GET'])
def GetMessages(request):
        message = Message.objects.all()
        serializer = MessageSerializer(message,many = True)
        return Response(serializer.data)

@api_view(['POST'])
def SendFcmToken(request):
    data = request.data
    user = Notification.objects.filter(userPhone = data.get('userPhone'))
    if(user.exists()):
         user.update(fcm_token = data.get('fcm_token'))
         return Response({'message': 'success'},status = status.HTTP_201_CREATED)
    else:
        serializer = NotificationSerializer(data = data)
        if serializer.is_valid():
                serializer.save()
                return Response({'message': 'success'},status = status.HTTP_201_CREATED)
        else:
                return Response({'message': 'Failed'},status = status.HTTP_400_BAD_REQUEST) 
    
