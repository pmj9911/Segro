from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.decorators import permission_classes
from rest_framework.permissions import IsAuthenticated
from django.http import JsonResponse
import math
import traceback
from user.models import Segro_User
from user.serializers import SegroUserSerializer
from bins.models import SmartBins
import  numpy as np
import json


# Create your views here.
@api_view(['GET',])
def user_list(request):
	try:
		usrs = Segro_User.objects.all()


	except:
		return Response(status=status.HTTP_404_NOT_FOUND)

	if request.method == 'GET':
		serializer = SegroUserSerializer(usrs,many=True)
		return Response(serializer.data)

@api_view(['POST',])
def nearby_bin(request):
	try:
		l = eval(request.body.decode('ASCII'))
		latitude = l['latitude']
		longitude = l['longitude']
		data = { "results" : { "latitude": latitude , "longitude": longitude}}

		distance=[]
		distance_sort=[]
		bin_list =SmartBins.objects.filter(bin_full=False).values()
		for i in bin_list:
			distance.append(math.acos((math.sin(i['latitude']))*(math.sin(latitude))+(math.cos(i['latitude']))*(math.cos(latitude))*math.cos(i['longitude']-longitude))*1000.0)
		print(bin_list)
		print(distance)
		distance_sort=distance
		distance_sort.sort()
		print(distance_sort)
		distance_sort=distance_sort[:10]


		indices= []
		for i in range(len(distance)):
			if distance[i] in distance_sort:
				indices.append(i)
		nearby_ten_bins={}
		list_ten_bins=[]
		dictionary={}
		lats = []
		longs = []
		names = []
		distances=[]
		for j in indices:
			dictionary["latitude"]= bin_list[j]["latitude"]
			lats.append(bin_list[j]["latitude"])
			dictionary["longitude"]=bin_list[j]["longitude"]
			longs.append(bin_list[j]["longitude"])
			dictionary["distance"]=float(distance[j])
			distances.append(distance[j])
			dictionary["names"]=bin_list[j]["location_name"]
			names.append(bin_list[j]["location_name"])
			
			list_ten_bins.append(dictionary.copy())

			#nearby_ten_bins[(j+1)] = dictionary
			# nearby_ten_bins=dict(nearby_ten_bins.items()+dictionary.items())
			print(dictionary)
		print(list_ten_bins)
		nearby_ten_bins["results"]=list_ten_bins
		print(type(nearby_ten_bins))
		return Response(nearby_ten_bins,content_type='application/json')


	except Exception as e:
		traceback.print_exc()
		print(e)
		return Response(status=405)

@api_view(['POST',])
def report(request):
	try:
		bin= NormalBins(lat=request.data["lat"], lng=request.data["lng"])
		lat=request.data["lat"]
		lng=request.data["lng"]
		bin_list =SmartBins.objects.all().values()
		flag=0
		for i in bin_list:
			distance=haversine(lat,lng,i['latitude'],i['longitude'])
			if(distance<0.1):
				flag=1
				break
		if(flag==0):
			nbin_list=NormalBins.objects.all()
			for j in nbin_list:
				distance=haversine(lat,lng,j.lat,j.lng)
				print(distance)
				if(distance<0.1):
					print("Already Reported")
					flag=1
					break
			if(flag==0):
				bin.save()
		return redirect('home')
	except Exception as e:
		traceback.print_exc()
		print(e)
		return Response(status=405)


 # @api_view(['GET',])
 # def bins_location(request):
 #    try:
	# 	bin_list =SmartBins.objects.all()
	# 	serializer = SmartBinSerializer(bin_list, many=True)
	# 	return Response(serializer.data)
	# except:
	# 	return Response(status=status.HTTP_404_NOT_FOUND)



# def nearby_bins(request, latitude, longitude, radius=1000, limit=10):
#
# 	user_location = fromstr("POINT(%s %s)" % (latitude, longitude))
# 	nearby_spots = SmartBins.objects.filter(x=(user_location, D(**desired_radius))).distance(user_location).order_by('distance')[:limit]
# 	serializer = SmartBinSerializer(nearby_spots, many=True)
#
# 	return JSONResponse(serializer.data)

