from rest_framework import serializers
from collector.models import Collector

class CollectorSerializer(serializers.ModelSerializer):
	class Meta:
		model = Collector
		fields = ['name','collector_id','collector_location','number_of_trips']