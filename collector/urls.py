from collector.views import collectors_list,bin_full,collection_route
from django.urls import path,include
app_name = 'collector'

urlpatterns = [
			path('collectors_list/',collectors_list,name='collectors_list'),
			path('binfull/',bin_full,name='bin_list'),
			path('route/',collection_route,name='tsproute'),
]