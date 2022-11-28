from django.http import JsonResponse
from .models import Patient 
from .serializers import PatientSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response 
from rest_framework import status

@api_view(['GET', 'POST'])
def patient_list(request, format=None):

    if request.method == 'GET':
       patients = Patient.objects.all()
       serializer = PatientSerializer(patients, many=True)
       return Response(serializer.data)
       #return JsonResponse({'patients': serializer.data})


    if request.method == 'POST':
        serializer = PatientSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)


@api_view(['GET', 'PUT', 'DELETE'])
def patient_detail(request, id, format=None):

    try:
        patient = Patient.objects.get(pk=id)
    except Patient.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = PatientSerializer(patient)
        return Response(serializer.data)
    elif request.method == 'PUT':
        serializer = PatientSerializer(patient, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == 'DELETE':
        patient.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


