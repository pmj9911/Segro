from bins.views import bins_list,simulation
from django.urls import path,include
app_name = 'bins'

urlpatterns = [
			path('bins_list/',bins_list,name='bins_list'),
			path('simulation/',simulation,name="simulation")]