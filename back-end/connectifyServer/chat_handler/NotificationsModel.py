from django.db import models

# Create your models here.
class Notification(models.Model):
      userPhone = models.CharField(max_length=255,null=False)
      fcm_token = models.CharField(null = False)