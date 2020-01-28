from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import IsAuthenticated
from bins.models import SmartBins
from bins.serializers import SmartBinSerializer

# Create your views here.
@api_view(['GET',])
def bins_list(request):
	try:
		list = SmartBins.objects.all()
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)

	if request.method == 'GET':
		serializer = SmartBinSerializer(list,many=True)
		return Response(serializer.data)