from collector.views import collectors_list
from django.urls import path,include
app_name = 'collector'

urlpatterns = [
			path('collectors_list/',collectors_list,name='collectors_list')]