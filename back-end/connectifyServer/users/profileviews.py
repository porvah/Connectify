from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .profileModel import Profile
from .profileSerializer import profileSerializer

@api_view(['Post'])
def Upload(request):
    data = request.data
    serializer = profileSerializer(data=data)
    profile = Profile.objects.filter(phone = data.get('phone'))
    if profile.exists():
        profile.update(image = data.get('image'))
        return Response({'message': 'Image uploaded successfully'}, status=status.HTTP_200_OK)
    else:
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Image uploaded successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['Get'])
def getPhotoes(request):
    user = Profile.objects.all()
    serializer = profileSerializer(user,many = True)
    return Response(serializer.data)