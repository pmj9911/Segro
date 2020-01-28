from django.db import models

# Create your models here.
class Segro_User(models.Model):
	username = models.CharField(max_length=50)
	user_location = models.CharField(max_length=50)