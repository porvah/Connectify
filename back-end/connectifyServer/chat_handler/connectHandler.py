from datetime import date
from asgiref.sync import sync_to_async


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
    from .NotificationsModel import Notification
    import os
    import requests
    from google.oauth2 import service_account
    from google.auth.transport.requests import Request
    from django.http import JsonResponse
    import json

    SERVICE_ACCOUNT_FILE = 'connectify-c3a03-firebase-adminsdk-r7csj-08a2a9989d.json'
    SCOPES = ['https://www.googleapis.com/auth/firebase.messaging']
    FCM_URL = 'https://fcm.googleapis.com/v1/projects/connectify-c3a03/messages:send'
    
    if not os.path.exists(SERVICE_ACCOUNT_FILE):
        return JsonResponse({'error': 'Service account file not found.'}, status=400)
    
    phone = data.get('receiver')
    if not phone:
        return JsonResponse({'error': 'Receiver phone number is missing.'}, status=400)
    
    notification = Notification.objects.filter(userPhone=phone).first()

    if not notification or not notification.fcm_token:
        return JsonResponse({'error': 'FCM token is missing or invalid for the user.'}, status=400)

    try:
        credentials = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
        
        credentials.refresh(Request())
        access_token = credentials.token
        if not access_token:
            return JsonResponse({'error': 'Failed to obtain access token.'}, status=400)
        
        print(f"Access Token: {access_token}")
        
        dataSaved = {
            "sender": data.get('sender'),
            "text": data.get('text')
        }
        
        payload = {
            "message": {
                "token": notification.fcm_token,
                "data": dataSaved
            }
        }
        
        print(f"Payload: {json.dumps(payload)}")
        
        headers = {
            'Authorization': f'Bearer {access_token}',
            'Content-Type': 'application/json',
        }
        
        response = requests.post(FCM_URL, headers=headers, data=json.dumps(payload))
        
        if response.status_code == 200:
            return JsonResponse({'message': 'Data message sent successfully.', 'response': response.json()})
        else:
            print(f"FCM Response: {response.text}")
            return JsonResponse({'error': 'Failed to send data message.', 'response': response.text}, status=response.status_code)

    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return JsonResponse({'error': f'An exception occurred: {str(e)}'}, status=500)


