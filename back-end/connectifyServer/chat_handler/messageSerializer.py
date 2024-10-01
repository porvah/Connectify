from rest_framework import serializers
from .messagemodels import Message

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
          model = Message
          fields = '__all__'