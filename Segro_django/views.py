from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from library.df_response_lib import *
from bins.models import SmartBins
from collector.models import Collector
from collector.views import nearBins
from user.views import nearby_bins
def landing_page(request):
	return render(request,'home.html')

def market_place(request):
	return render(request,'market_place.html')

def learn_more(request):
	return render(request,'awareness.html')

def get_types():
	# set fulfillment text
	fulfillmentText = 'Hello! are you an Admin, User or a Collector?'
	#create suggestion chips
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)
	return reply

def get_response(_type):
	if _type == "user":
		fulfillmentText = 'Hello User! what do you want to do?'
	elif _type == "admin":
		fulfillmentText = 'Hello Admin! Please type your password'
	elif _type == "collector":
		fulfillmentText = 'Hello Collector! Please enter your collector ID.'
	else:
		fulfillmentText = 'Error! the user type does not exist'
	#create suggestion chips
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)
	return reply

def admin_auth(password):
	if password == "admin123":
		fulfillmentText = 'Access Granted!!! Please tell which action do you want to take? 1. Get a list of bins. \n 2. Get a list of collectors.'
	#create suggestion chips
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)
	return reply

def collector_auth_route(password):
	if password == "collect123":
		fulfillmentText = 'Hello Collector 1 ! These are the routes available for you ! ............'
	elif password == "collector123":
		fulfillmentText = 'Hello Collector 2 !These are the routes available for you ! ............'	
	#create suggestion chips
	else:
		fulfillmentText = "Wrong password"
	fulfillmentText += nearBins()

	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)
	return reply

def admin_use(section):
	if section == "collector":
		collectors = (Collector.objects.all()[:]).values()[:]
		fulfillmentText = ""
		print(collectors[0])
		for i in range(len(collectors)):
			# 'name': 'abc', 'collector_id': 1, 'collector_location': 'kandivali', 'col_lat': 12.654, 'col_lng': 75.6444, 'number_of_trips': 0
			fulfillmentText += (str(i+1) + " ." + collectors[i]['name'] + " ~ " + str(collectors[i]['collector_location']) + " ~ " + str(collectors[i]['number_of_trips'])  + " |")
	elif section == "bins":
		bins = (SmartBins.objects.all()[:]).values()[:]
		fulfillmentText = ""
		print(bins[0])
		for i in range(len(bins)):
			fulfillmentText += (str(i+1) + " ." + bins[i]['location_name'] + " ~ " + str(bins[i]['garbage_value']) + " |")
		

	#create suggestion chips
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)	
	return reply

def user_enquiry():
	fulfillmentText = "Hello user, These are the 10 nearby bins to you! ____"  + str(nearby_bins())
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)
	return reply

def collector_route():
	fulfillmentText = nearBins()
	print("````````````````````````````````````````````````````````")
	print(fulfillmentText)
	ff_response = fulfillment_response()
	ff_text = ff_response.fulfillment_text(fulfillmentText)
	reply = ff_response.main_response(ff_text)
	print(reply)	
	return reply

@csrf_exempt
def webhook(request):
	# build a request object
	req = json.loads(request.body)
	#get action from json
	action = req.get('queryResult').get('action')
	# prepare response for suggestion chips
	if action == 'get_types':
		reply = get_types()
	elif action == 'get_response':
		_type = req.get('queryResult').get('parameters').get('Type')
		reply = get_response(_type)
	elif action == 'admin_auth':
		password = req.get('queryResult').get('parameters').get('password')
		print(password)
		reply = admin_auth(password)
	elif action == 'admin-usage':
		section = req.get('queryResult').get('parameters').get('admin-use')
		print(section)
		reply = admin_use(section)
	elif action == 'user_enquiry':
		# name = 
		reply = user_enquiry()
	elif action == 'collector_auth_route':
		password = req.get('queryResult').get('parameters').get('password')
		print(password)
		reply = collector_auth_route(password)
	return JsonResponse(reply, safe=False)
