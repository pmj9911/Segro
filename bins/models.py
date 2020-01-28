from django.db import models

# Create your models here.
class SmartBins(models.Model):
	latitude = models.IntegerField()
	longitude = models.IntegerField()
	location_name = models.CharField(max_length=50)
	threshold_value = models.FloatField()

