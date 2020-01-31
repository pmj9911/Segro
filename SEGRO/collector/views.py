from django.shortcuts import render
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import IsAuthenticated
from collector.models import Collector
from collector.serializers import CollectorSerializer

# Create your views here.
@api_view(['GET',])
def collectors_list(request):
	try:
		list = Collector.objects.all()
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method == 'GET':
		serializer = CollectorSerializer(list,many=True)
		return Response(serializer.data)

