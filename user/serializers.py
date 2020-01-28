from rest_framework import serializers
from user.models import Segro_User

class SegroUserSerializer(serializers.ModelSerializer):
	class Meta:
		model = Segro_User
		fields = ['username','user_location']