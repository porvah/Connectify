from django.utils import timezone
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .userserializers import UserSerializer
from .models import User
from .userAuthModel import UserAuthModel
from .authprocess import SaveUser,ValidateCode,LogUser

# Create your views here.

@api_view(['Post'])
def SignUpAuthentication(request):
    data = request.data
    email = data.get('email')
    phone = data.get('phone')
    code = data.get('code')
    try:
        user = UserAuthModel.objects.get(email = email)
        if user.code == code:
            if ValidateCode(user.time):
                savedData = UserAuthModel.objects.filter(email = email).values('email', 'phone').first()
                UserAuthModel.objects.filter(email = email).delete()
                if(SaveUser(savedData) == "success"):
                    token = LogUser(email , phone)
                    return Response({"token" : token}, status=status.HTTP_200_OK)
                else:
                    return Response({'message': 'failed'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response({'message': 'expired code'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({'message': 'wrong code'}, status=status.HTTP_404_NOT_FOUND)
    except UserAuthModel.DoesNotExist:
        return Response({'error': 'email not found'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['Post'])
def LogInAuthentication(request):
    data = request.data
    email = data.get('email')
    phone = data.get('phone')
    code = data.get('code')
    try:
        user = UserAuthModel.objects.get(email = email)
        if user.code == code:
            if ValidateCode(user.time):
                UserAuthModel.objects.filter(email = email).delete()
                token = LogUser(email , phone)
                return Response({"token" : token}, status=status.HTTP_200_OK)
            else:
                return Response({'message': 'expired code'}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({'message': 'wrong code'}, status=status.HTTP_404_NOT_FOUND)
    except UserAuthModel.DoesNotExist:
        return Response({'error': 'email not found'}, status=status.HTTP_404_NOT_FOUND)
