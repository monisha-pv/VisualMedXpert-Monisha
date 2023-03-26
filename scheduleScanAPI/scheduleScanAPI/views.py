from django.http import JsonResponse
from .models import scheduleScan
from .serializers import scheduleScanSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status 

@api_view(['GET', 'POST'])
def scan_list(request, format=None):
    if request.method == 'GET':
        scans = scheduleScan.objects.all()
        serializer = scheduleScanSerializer(scans, many=True)
        return Response(serializer.data)

    if request.method == 'POST':
            serializer = scheduleScanSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)



@api_view(['GET', 'PUT', 'DELETE'])
def scan_detail(request, id, format=None):
  
    try:
       scan = scheduleScan.objects.get(pk=id)
    except scheduleScan.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = scheduleScanSerializer(scan)
        return Response(serializer.data)
        
    elif request.method == 'PUT':
        serializer = scheduleScanSerializer(scan, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        scan.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


