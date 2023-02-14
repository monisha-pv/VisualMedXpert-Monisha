from rest_framework import serializers
from .models import scheduleScan

class scheduleScanSerializer(serializers.ModelSerializer):
    class Meta:
        model = scheduleScan
        fields = ['id', 'name', 'gender', 'condition', 'scanType', 'centre', 'date', 'time']
