from django.shortcuts import render
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import IsAuthenticated
from collector.models import Collector
from bins.models import SmartBins,NormalBins
from collector.serializers import CollectorSerializer,BinSerializer
from collector.TSP import main
import numpy as np
from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp
import googlemaps
import json
import gmaps
from django.http import JsonResponse
from user.distance import haversine


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

@api_view(('GET',))
def bin_full(request):
	try:
		list_of_bins = SmartBins.objects.filter(needs_to_be_collected=True)
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method == 'GET':
		serializer = BinSerializer(list_of_bins,many=True)
		return Response(serializer.data)


@api_view(('GET',))
def collection_route(request):
	try:
		list_of_bins = SmartBins.objects.filter(needs_to_be_collected=True)
		list_of_nbins=NormalBins.objects.all()
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method=='GET':
		Mode = "driving"  # "driving", "walking", "bicycling", "transit"	
		password = ""
		lat= [15.384224]
		lng= [73.82342]
		# collec=Collector.objects.all()
		# c=collec[0]
		# lat.append(c.col_lat)
		# lng.append(lng[0])
		print(lat,lng)
		dist=[]
		for k in list_of_bins:
			dist1=haversine(lat[0],lng[0],k.latitude,k.longitude)
			print(dist1)
			if(dist1<15):
				 lat.append(k.latitude)
				 lng.append(k.longitude)
				 dist.append(dist1)
		for h in list_of_nbins:
			dist2=haversine(lat[0],lng[0],h.lat,h.lng)
			if(dist2<15):
				 lat.append(h.lat)
				 lng.append(h.lng)
				 dist.append(dist2)
		lat=np.array(lat)
		lng=np.array(lng)
		lat = lat.astype(float)
		lng = lng.astype(float)
		print(dist)

		# calculate the dist_matrix
		# distance unit: meter
		gmaps = googlemaps.Client(key=password)
		dist_matrix = []
		places=len(lat)
		print(places)
		for i in range(places):
			for j in range(places):
				x = (lat[i], lng[i])
				y = (lat[j], lng[j])
				directions_result = gmaps.directions(x,y,mode=Mode,avoid="ferries")
				dist_matrix.append(directions_result[0]['legs'][0]['distance']['value'])
		dist_matrix = np.reshape(dist_matrix, (places, places))
		# dist_matrix.astype(int)
		dist_matrix
		# convert the dist_matrix to a symmetrical matrix
		dist_matrix = np.asmatrix(dist_matrix)
		for i in range(0,places, 1):
			for j in range(i+1, places, 1):
				dist_matrix[j,i] = dist_matrix[i,j]
		dist_matrix = np.asarray(dist_matrix)
		Index= main(places,dist_matrix,lat,lng)
		new_lat = [lat[0]]
		new_lng = [lng[0]]
		print(lat)
		print(lng)
		for i in range(places-1):
			index = Index[i].astype(int)
			new_lat = np.append(new_lat, lat[index])
			new_lng = np.append(new_lng, lng[index])
		new_lat = np.append(new_lat, lat[0])
		new_lng = np.append(new_lng, lng[0])
		l=len(new_lat)
		print(new_lat)
		print(new_lng)
		data = {'result' :[{"lat":new_lat[i],"long":new_lng[i]} for i in range(l)]}
		return JsonResponse(data)
                    


