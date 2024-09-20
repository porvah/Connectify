from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .userserializers import UserSerializer
from .authserializer import AuthSerializer
from .userAuthModel import UserAuthModel
from .models import User
from django.utils import timezone
from .randomCodeGenerator import generateCode
from django.db.models import Q


# Create your views here.

@api_view(['Post'])
def SignUp(request):
        code = generateCode()
        time = timezone.now().time()
        savedData = request.data
        savedData['code'] = code
        savedData['time'] = time
        serializer = AuthSerializer(data = savedData)
        user = User.objects.filter(Q(email=savedData.get('email')) | Q(phone=savedData.get('phone')))
        if(not user.exists()):
                if serializer.is_valid():
                        serializer.save()
                        return Response(serializer.data,status = status.HTTP_201_CREATED)
                else:
                    return Response(serializer.data,status=status.HTTP_400_BAD_REQUEST)
        else:
             return Response({'message': 'User Exists'},status=status.HTTP_400_BAD_REQUEST)  

@api_view(['GET'])
def Get(request):
        print(UserAuthModel.objects.all())
        usersAuth = UserAuthModel.objects.all()
        serializer = AuthSerializer(usersAuth,many = True)
        return Response(serializer.data)

@api_view(['GET'])
def GetSavedUsers(request):
        print(User.objects.all())
        user = User.objects.all()
        serializer = UserSerializer(user,many = True)
        return Response(serializer.data)
       
    

