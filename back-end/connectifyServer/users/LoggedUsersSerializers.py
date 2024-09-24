from rest_framework import serializers
from users.loggedusersmodel import LoggedUsersModel

class LoggedUsersSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoggedUsersModel
        fields = '__all__'