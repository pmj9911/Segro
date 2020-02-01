from django.shortcuts import render,redirect

def landing_page(request):
	return render(request,'home.html')

def market_place(request):
	return render(request,'market_place.html')

def learn_more(request):
	return render(request,'awareness.html')