from asgiref.sync import sync_to_async
import uuid
import json

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
    messages_list = list(messages.values('id', 'sender',
     'text', 'time', 'attachment_name', 'attachment', 'message_id', 'hasattachment', 'signal','replied'))
    Message.objects.filter(receiver = phone).delete()
    return messages_list