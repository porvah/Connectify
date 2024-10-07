from rest_framework import serializers
from .profileModel import Profile

class profileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'