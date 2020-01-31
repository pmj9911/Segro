import traceback
from django.shortcuts import render
from rest_framework import status
from django.http import HttpResponse
from rest_framework.response import Response
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import IsAuthenticated
from bins.models import SmartBins
from bins.serializers import SmartBinSerializer
from random import randint
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

@api_view(['GET',])
def simulation(request):
	try:
		# while(True):
			#fetch the values of all bins from the database for which to be collected is false
			#select a random bin
			#increase the garbage value of the bin
			#check if the value is less than threshold
			#if value less than threshold update the garbage value
			#else if greater,change to_be_collected to true and continue
		threshold = 75
		list_of_bins = SmartBins.objects.filter(needs_to_be_collected=False).values()
		count = len(list_of_bins)
		# print(list_of_bins.values())
		try:
			random_bin = SmartBins.objects.filter(needs_to_be_collected=False).values()[randint(0,count-1)]
		except:
			return HttpResponse({'all bins full'},status=200)
		# print(len(list_of_bins))
		# print(random_bin['garbage_value'])
		if(random_bin['garbage_value']>= threshold):
			if (random_bin['garbage_value']>=100):
				random_bin['bin_full']=True
				random_bin['needs_to_be_collected']=True
			else:
				random_bin['garbage_value']=random_bin['garbage_value']+25
				random_bin['needs_to_be_collected']=True
			# print("inside if")
			# print(threshold)
			
			# print(random_bin['needs_to_be_collected'])
		else:
			# print("inside else")
			random_bin['garbage_value']=random_bin['garbage_value']+25
		# print(random_bin)
		# print(random_bin['id'])
		selected_bin = SmartBins.objects.get(pk=random_bin['id'])
		# print(selected_bin)
		selected_bin.garbage_value=random_bin['garbage_value']
		selected_bin.needs_to_be_collected=random_bin['needs_to_be_collected']
		selected_bin.save()
		full_bins = SmartBins.objects.filter(needs_to_be_collected=True)
	except Exception as e:
		traceback.print_exc()
		print(e)
		return HttpResponse(status=403)
	# if reuqest.method=='GET':
	if request.method == 'GET':
		serializer = SmartBinSerializer(full_bins,many=True)
		# print("inside get")
		return Response(serializer.data)

