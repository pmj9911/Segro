from django.db import models

# Create your models here.
class Collector(models.Model):
	name = models.CharField(max_length=50)
	collector_id = models.IntegerField()
	collector_location = models.CharField(max_length=50)
	number_of_trips = models.IntegerField()