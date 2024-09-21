from .models import User
from .userserializers import UserSerializer
from django.core.mail import send_mail
from django.conf import settings
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

