from django.contrib import admin
from .models import SmartBins,NormalBins
# Register your models here.
admin.site.register(SmartBins)
admin.site.register(NormalBins)