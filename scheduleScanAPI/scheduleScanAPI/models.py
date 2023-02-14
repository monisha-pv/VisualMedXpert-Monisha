from django.db import models 

class scheduleScan(models.Model):
    name = models.CharField(max_length=200)
    gender = models.CharField(max_length=50)
    condition = models.CharField(max_length=200)
    scanType = models.CharField(max_length=100)
    centre = models.CharField(max_length=200)
    date = models.CharField(max_length=50)
    time = models.CharField(max_length=50)


    def __str__(self):
        return self.name + ' ' + self.gender