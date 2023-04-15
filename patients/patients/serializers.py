from rest_framework import serializers
from .models import Patient


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = ['id', 'fullname', 'dob', 'gender', 'nhsNo', 'address', 'medcondition', 'patientdescription', 'symptoms', 'medication', 'notes']