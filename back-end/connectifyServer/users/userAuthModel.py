from django.db import models

class UserAuthModel(models.Model):
    email = models.CharField(max_length=255,null = False,unique=True)
    phone = models.CharField(max_length=15 , null=False,unique=True)
    code = models.CharField(max_length=8)
    time = models.TimeField()
