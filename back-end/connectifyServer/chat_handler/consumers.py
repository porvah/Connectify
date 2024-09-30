import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from .connectHandler import get_user_phone

# A global dictionary to store connected users by phone number
connected_users = {}

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        # The phone number will be passed through the URL when the user connects
        self.token = self.scope['url_route']['kwargs']['token']
        self.phone_number = await get_user_phone(self.token)
        print(f"User with phone number {self.phone_number} is trying to connect.")

        # Add the user's WebSocket channel to the connected_users dictionary
        connected_users[self.phone_number] = self.channel_name

        # Accept the WebSocket connection
        await self.accept()

    async def disconnect(self, close_code):
        # Remove the user's connection from the connected_users dictionary on disconnect
        if self.phone_number in connected_users:
            del connected_users[self.phone_number]

    # Receive message from WebSocket
    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data['message']
        sender = data['sender']
        receiver = data['receiver']

        # Check if the receiver is connected
        if receiver in connected_users:
            # Send message directly to the receiver's WebSocket connection
            await self.channel_layer.send(
                connected_users[receiver],  # The channel name of the receiver
                {
                    'type': 'chat_message',
                    'message': message,
                    'sender': sender,
                }
            )
        else:
            # Handle case where the receiver is not connected (optional)
            await self.send(text_data=json.dumps({
                'error': 'Receiver is not connected.',
            }))
            return connected_users

    # Handle the incoming message and send it to the WebSocket client (receiver)
    async def chat_message(self, event):
        message = event['message']
        sender = event['sender']
         
        # Send the message to the WebSocket client (receiver)
        await self.send(text_data=json.dumps({
            'message': message,
            'sender': sender,
        }))
        print("success")
