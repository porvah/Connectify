from .models import User
from .userserializers import UserSerializer


def SaveUser(savedData):
    user_data = {
    'email': savedData.get('email'),
    'phone': savedData.get('phone')
    }
    serializer = UserSerializer(data = user_data)
    if serializer.is_valid():
        serializer.save()
        return "success"
    return "failed"


