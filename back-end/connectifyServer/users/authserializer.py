from rest_framework import serializers
from users.userAuthModel import UserAuthModel

class AuthSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserAuthModel
        fields = '__all__'