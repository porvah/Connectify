import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from .connectHandler import get_user_phone,generateID,saveUser,getQueuedMessages

connected_users = {}

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.token = self.scope['url_route']['kwargs']['token']
        self.phone_number = await get_user_phone(self.token)
        connected_users[self.phone_number] = self.channel_name
        queuedMessages = await getQueuedMessages(self.phone_number)
        await self.accept()
        await self.send(text_data=json.dumps(queuedMessages))

    async def disconnect(self, close_code):
        if self.phone_number in connected_users:
            del connected_users[self.phone_number]

    async def receive(self, text_data):
        data = json.loads(text_data)
        data['type'] = 'chat_message'
        data['message_id'] = generateID()
        receiver = data['receiver']

        await self.send(text_data=json.dumps({
            'message_id' : data.get('message_id'),
        }))

        if receiver in connected_users:
            await self.channel_layer.send(
                connected_users[receiver],
                data  
            )
        else:
            await saveUser(data)
            await self.send(text_data=json.dumps({
               'message' : 'user not connected',
            }))
            return connected_users

    async def chat_message(self, event):
        del event['type']
        await self.send(text_data=json.dumps(event))
        print("success")
