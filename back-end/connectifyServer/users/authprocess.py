from datetime import datetime, timezone
from django.utils import timezone
from .models import User
from .userserializers import UserSerializer
from .LoggedUsersSerializers import LoggedUsersSerializer
from .loggedusersmodel import LoggedUsersModel
from django.core.mail import send_mail
from django.conf import settings
from .randomCodeGenerator import generateSessionCode
import logging


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


def SendEmail(code, email):
    try:
        send_mail(
            'Welcome to Connectify',
            f'Your authentication code is: {code}',
            settings.EMAIL_HOST_USER,
            [email],
            fail_silently=False,
        )
    except Exception as e:
        logging.error(f"Error sending email: {e}")


from datetime import datetime
from django.utils import timezone

def ValidateCode(saved_time):
    if isinstance(saved_time, str):
        saved_time = datetime.strptime(saved_time, '%H:%M:%S').time()  

    current_datetime = timezone.now()  
    saved_datetime = datetime.combine(current_datetime.date(), saved_time)
    saved_datetime = timezone.make_aware(saved_datetime)

    time_difference = current_datetime - saved_datetime
    difference_in_seconds = time_difference.total_seconds()
    print(difference_in_seconds)

    return difference_in_seconds <= 5*60  


def LogUser(email,phone):
    from chat_handler.consumers import ChatConsumer
    token = generateSessionCode()
    data = {
        'email' : email,
        'phone' : phone,
        'token' : token
    }
    loggeduser = LoggedUsersModel.objects.filter(email = data.get('email'))
    connectedUser = LoggedUsersModel.objects.get(email = data.get('email'))
    print(connectedUser.phone)
    serializer = LoggedUsersSerializer(data = data)
    if loggeduser.exists():
        ChatConsumer.send_signal(connectedUser.phone)
        loggeduser.update(token = token)
    else:
        if serializer.is_valid():
            serializer.save()
    return token








