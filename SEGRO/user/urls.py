from user.views import user_list, nearby_bin
from django.urls import path,include
from rest_framework.urlpatterns import format_suffix_patterns

app_name = 'user'

urlpatterns = [
			path('user_list/',user_list,name='user_list'),
			path('nearby_bin/',nearby_bin, name='nearby_bin')]