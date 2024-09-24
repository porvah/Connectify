from django.db import models
# Create your models here.

class User(models.Model):
    email = models.CharField(max_length=255,unique=True,null=False)
    phone = models.CharField(max_length=15,unique=True,null=False)
    
    
