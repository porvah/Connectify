from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .userserializers import UserSerializer
from .authserializer import AuthSerializer
from .LoggedUsersSerializers import LoggedUsersSerializer
from .userAuthModel import UserAuthModel
from .models import User
from .loggedusersmodel import LoggedUsersModel
from django.utils import timezone
from .randomCodeGenerator import generateCode
from django.db.models import Q
from .authprocess import SendEmail


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
        userauth = UserAuthModel.objects.filter(email = savedData.get('email'))
        if(not user.exists()):
                if (userauth.exists()):
                       userauth.update(code = code , time = time)
                       SendEmail(code,savedData.get('email'))
                       return Response({'message': 'success'},status = status.HTTP_201_CREATED)
                else: 
                        if serializer.is_valid():
                                serializer.save()
                                SendEmail(code,savedData.get('email'))
                                return Response({'message': 'success'},status = status.HTTP_201_CREATED)
                        else:
                             return Response({'message': 'failed'},status=status.HTTP_400_BAD_REQUEST)
        else:
             return Response({'message': 'User Exists'},status=status.HTTP_400_BAD_REQUEST)


@api_view(['Post'])
def LogIn(request):
        code = generateCode()
        time = timezone.now().time()
        savedData = request.data
        savedData['code'] = code
        savedData['time'] = time
        serializer = AuthSerializer(data = savedData)
        user = User.objects.filter(email=savedData.get('email') , phone=savedData.get('phone'))
        userauth = UserAuthModel.objects.filter(email = savedData.get('email'))
        if(user.exists()):
                if userauth.exists():
                       userauth.update(code = code , time = time)
                       SendEmail(code,savedData.get('email'))
                       return Response({'message': 'success'},status = status.HTTP_201_CREATED)
                else:       
                        if serializer.is_valid():
                                serializer.save()
                                SendEmail(code,savedData.get('email'))
                                return Response({'message': 'success'},status = status.HTTP_201_CREATED)
                        else:
                            return Response({'message': 'failed'},status=status.HTTP_400_BAD_REQUEST)
        else:
             return Response({'message': 'User doesnot exist'},status=status.HTTP_400_BAD_REQUEST)
        

@api_view(['Post'])
def ResendCode(request):
       savedData = request.data
       code = generateCode()
       time = timezone.now().time()
       UserAuthModel.objects.filter(email = savedData.get('email')).update(code = code,time = time)
       SendEmail(code,savedData.get('email')) 
       return Response({'message': 'success'}, status=status.HTTP_200_OK) 


@api_view(['Post'])
def LogOut(request):
       try:
          data = request.data
          email = data.get('email')
          LoggedUsersModel.objects.filter(email = email).delete()
          return Response({'message': 'success'}, status=status.HTTP_200_OK)
       except LoggedUsersModel.DoesNotExist:
              return Response({'error': 'failed'}, status=status.HTTP_404_NOT_FOUND)
       
@api_view(['Post'])
def OpenSession(request):
       data = request.data
       token = data.get('token')
       user = LoggedUsersModel.objects.filter(token = token)
       if user.exists():
              return Response({'message': 'success'}, status=status.HTTP_200_OK)
       else:
            return Response({'message': 'start new session'}, status=status.HTTP_404_NOT_FOUND)  
              

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

@api_view(['GET'])
def GetLoggedUsers(request):
        print(LoggedUsersModel.objects.all())
        user = LoggedUsersModel.objects.all()
        serializer = LoggedUsersSerializer(user,many = True)
        return Response(serializer.data)
       
    

