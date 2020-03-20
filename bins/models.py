from django.db import models

# Create your models here.

WASTE_TYPES = (('cardboard','Cardboard'),
	('glass','Glass'),
	('metal','Metal'),
	('paper','Paper'),
	('plastic','Plastic'),
	('trash','Trash'))
class SmartBins(models.Model):
	latitude = models.FloatField()
	longitude = models.FloatField()
	location_name = models.CharField(max_length=50)
	garbage_value = models.FloatField()
	waste_type = models.CharField(max_length=10,choices=WASTE_TYPES,default="cardboard")
	needs_to_be_collected = models.BooleanField(default=False)
	bin_full = models.BooleanField(default=False)
	waste_collected = models.BooleanField(default=False)

	def __str__(self):
		return self.location_name +  str(self.needs_to_be_collected)

class NormalBins(models.Model):
	lat= models.FloatField()
	lng = models.FloatField()
#	model_pic = models.ImageField(upload_to = 'images/')
