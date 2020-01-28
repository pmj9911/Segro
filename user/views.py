from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import IsAuthenticated
from user.models import Segro_User
from user.serializers import SegroUserSerializer

# Create your views here.
@api_view(['GET',])
def user_list(request):
	try:
		list = Segro_User.objects.all()
	except:
		return Response(status=status.HTTP_404_NOT_FOUND)
	if request.method == 'GET':
		serializer = SegroUserSerializer(list,many=True)
		return Response(serializer.data)
