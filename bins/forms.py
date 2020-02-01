from django import forms
from django.forms import ModelForm
from bins.models import NormalBins


class BinCreationForm(ModelForm):
    class Meta:
        model = NormalBins
        fields = ['lat','lng']
        
