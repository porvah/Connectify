from django.db import models

class Profile(models.Model):
    image = models.ImageField(upload_to='profile_images/')
    phone = models.CharField(max_length=255,null = False)