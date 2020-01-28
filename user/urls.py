from user.views import user_list
from django.urls import path,include
app_name = 'user'

urlpatterns = [
			path('user_list/',user_list,name='user_list')]