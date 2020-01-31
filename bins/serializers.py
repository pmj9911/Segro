from rest_framework import serializers
from bins.models import SmartBins

class SmartBinSerializer(serializers.ModelSerializer):
	class Meta:
		model = SmartBins
		fields = ['latitude','longitude','location_name','garbage_value','waste_type','needs_to_be_collected','bin_full','waste_collected']