from django.urls import path
from .consumers import ChatConsumer

websocket_urlpatterns = [
    path('ws/chat/<str:phone_number>/', ChatConsumer.as_asgi()),
]
