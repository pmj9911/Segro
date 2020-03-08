from bins.views import bins_list,simulation,bin_information,reset_information#,waste_type
from django.urls import path,include
app_name = 'bins'

urlpatterns = [
			path('bins_list/',bins_list,name='bins_list'),
			path('simulation/',simulation,name="simulation"),
			path('bin_information/',bin_information,name="bin_information"),
			path('reset_information/',reset_information,name="reset_information"),
			# path('waste_type',waste_type,name="waste_type")
			]