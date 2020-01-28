from rest_framework import serializers
from bins.models import SmartBins

class SmartBinSerializer(serializers.ModelSerializer):
	class Meta:
		model = SmartBins
		fields = ['latitude','longitude','location_name','threshold_value']