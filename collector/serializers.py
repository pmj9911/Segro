from rest_framework import serializers
from collector.models import Collector
from bins.models import SmartBins

class CollectorSerializer(serializers.ModelSerializer):
	class Meta:
		model = Collector
		fields = ['name','collector_id','collector_location','number_of_trips']

class BinSerializer(serializers.ModelSerializer):
	class Meta:
		model = SmartBins
		fields = ['location_name','latitude','longitude']


 