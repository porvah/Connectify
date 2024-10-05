import json
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .profileModel import Profile
from .profileSerializer import profileSerializer

@api_view(['POST'])
def Upload(request):
    phone = request.data.get('phone')
    profile = Profile.objects.filter(phone=phone).first()

    if profile:
        if 'image' in request.FILES:
            profile.image = request.FILES['image'] 
            profile.save()  
            return Response({'message': 'Image uploaded successfully'}, status=status.HTTP_200_OK)
        else:
            return Response({'message': 'No image provided'}, status=status.HTTP_400_BAD_REQUEST)

    serializer = profileSerializer(data=request.data) 
    if serializer.is_valid():
        serializer.save()  
        return Response({'message': 'Profile created and image uploaded successfully'}, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def getImage(request):
    try:
        data = json.loads(request.body)
        phone = data.get('phone')
        user = Profile.objects.filter(phone=phone)      
        if user.exists():
            image_path = user.first().image.url 
            full_image_url = request.build_absolute_uri(image_path)          
            return Response({'image': full_image_url}, status=status.HTTP_200_OK)        
        return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)
    except json.JSONDecodeError:
        return Response({'error': 'Invalid JSON'}, status=status.HTTP_400_BAD_REQUEST)

    
@api_view(['Get'])
def getPhotoes(request):
    user = Profile.objects.all()
    serializer = profileSerializer(user,many = True)
    return Response(serializer.data)