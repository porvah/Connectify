from datetime import date
from asgiref.sync import sync_to_async
import uuid
import json
import requests
from django.http import JsonResponse
from google.auth.transport.requests import Request
from google.oauth2 import service_account

@sync_to_async
def get_user_phone(token):
    from users.loggedusersmodel import LoggedUsersModel
    user = LoggedUsersModel.objects.filter(token=token).first()
    return user.phone

@sync_to_async
def saveUser(data):
    from . messageSerializer import MessageSerializer
    del data['type']
    serializer = MessageSerializer(data = data)
    if serializer.is_valid():
        serializer.save()

@sync_to_async
def getQueuedMessages(phone):
    from . messagemodels import Message
    messages = Message.objects.filter(receiver = phone)
    messages_list = list(messages.values('id', 'sender','receiver',
     'text', 'time', 'attachment', 'message_id', 'signal','replied'))
    Message.objects.filter(receiver = phone).delete()
    return messages_list

@sync_to_async
def SendDataMessage(data):
    from NotificationsModel import Notification
    SERVICE_ACCOUNT_FILE = 'connectify-c3a03-firebase-adminsdk-r7csj-08a2a9989d.json'
    SCOPES = ['https://www.googleapis.com/auth/firebase.messaging']
    FCM_URL = 'https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send'
    
    phone = data.get('receiver')
    notification = Notification.objects.filter(userPhone = phone).first()

    credentials = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    credentials.refresh(Request())
    
    dataSaved = {
        "sender" : data.get('sender'),
        "text" : data.get('text')
    }

    payload = {
        "message": {
            "token": notification.fcm_token,
            "data": dataSaved
        }
    }

    access_token = credentials.token

    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json',
    }

    response = requests.post(FCM_URL, headers=headers, data=json.dumps(payload))

    if response.status_code == 200:
        return JsonResponse({'message': 'Data message sent successfully.', 'response': response.json()})
    else:
        return JsonResponse({'error': 'Failed to send data message.', 'response': response.text}, status=response.status_code)

