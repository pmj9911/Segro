from django.shortcuts import render,redirect

def landing_page(request):
	return redirect(request,'Segro_django/landing_page.html')