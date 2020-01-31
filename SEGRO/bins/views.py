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
import json
from django.core import serializers
from django.http import JsonResponse
from django.forms.models import model_to_dict
import cv2
import numpy as np
from keras.preprocessing import image
from keras.models import load_model

# Create your views here.
@api_view(['GET',])
def bins_list(request):
	try:
		list = SmartBins.objects.all()
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)

	if request.method == 'GET':
		serializer = SmartBinSerializer(list,many=True)
		qs = dict(serializer.data[0])
		return Response(qs)

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
			ctx = {
			"reason" : "string",
			}
			return Response(ctx,content_type='application/json',status=200)
		# print(len(list_of_bins))
		# print(random_bin['garbage_value'])
		if(random_bin['garbage_value']>= threshold):
			if (random_bin['garbage_value']>=100):
				random_bin['bin_full']=True
				random_bin['waste_collected']=True
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
		try:
			serializer = SmartBinSerializer(full_bins,many=True)
			# print("inside get")
			qs = dict(serializer.data[0])
			return Response(qs)
		except Exception as e:
			print(e)
			return Response({'reason':'all bins empty'},content_type='application/json',status=200)
@api_view(['POST',])
def bin_information(request):
	try:
		# latitude = float(request.POST.get('latitude'))
		# longitude = float(request.POST.get('longitude'))
		l = eval(request.body.decode('ASCII'))
		latitude = l['latitude']
		longitude = l['longitude']
		print(latitude)
		list_of_bins = SmartBins.objects.filter(latitude=latitude,longitude=longitude).values()
		# for key,value in list_of_bins:
		# 	print(key,value)
		# print(dtype(list_of_bins))
		# print(list_of_bins.values())
		# json_list = json.dumps(list_of_bins)
		# list_of_bins = serializers.serialize('json', self.get_queryset())
		# return Response(list_of_bins, content_type='application/json',status=200)
	except Exception as e:
		traceback.print_exc()
		print(e)
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method == 'POST':
			serializer = SmartBinSerializer(list_of_bins,many=True)
			# print("inside get")
			qs = dict(serializer.data[0])
			return Response(qs)

@api_view(['GET',])
def reset_information(request):
	try:
		list_of_bins = SmartBins.objects.filter(waste_collected=True).values()
		for i in list_of_bins:
			i['garbage_value']=0
			selected_bin = SmartBins.objects.get(pk=i['id'])
			selected_bin.garbage_value = 0
			selected_bin.needs_to_be_collected=False
			print("HO raha hai")
			selected_bin.save()
	except Exception as e:
		traceback.print_exc()
		print(e)
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method == 'GET':
		serializer = SmartBinSerializer(list_of_bins,many=True)
		qs = dict(serializer.data[0])
		return Response(qs)

@api_view(['POST',])
def waste_type(request):
	try:
		waste_image = request.data['file']
		print(waste_image)
		saved_model = load_model('.\\model_keras.h5')
		img = cv2.imread('.\\media\\cardboard4.jpg')
		# print(img)
		img = cv2.resize(img,(300,300))
		x = image.img_to_array(img)
		x = np.expand_dims(x, axis=0)
		images = np.vstack([x])
		classes = saved_model.predict_classes(images, batch_size=10)
		print(classes)
		waste_type = ""
		if classes == 0:
  			waste_type="classboard"
		elif classes == 1:
  			waste_type="glass"
		elif classes == 2:
  			waste_type="metal"
		elif classes == 3:
  			waste_type="paper"
		elif classes == 4:
  			waste_type="plastic"
		elif classes == 5:
  			waste_type="trash"
		return Response({'waste_type':waste_type},content_type='application/json')
	except Exception as e:
		traceback.print_exc()
		return Response(status=status.HTTP_404_NOT_FOUND)



