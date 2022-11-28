from django.db import models


class Patient(models.Model):
    fullname = models.CharField(max_length=200)
    dob = models.CharField(max_length=200)
    address = models.CharField(max_length=300)
    medcondition = models.CharField(max_length=300)
    patientdescription = models.CharField(max_length=600)
    symptoms = models.CharField(max_length=500)
    medication = models.CharField(max_length=500)
    notes = models.CharField(max_length=600)

    def __str__(self):
        return self.fullname + ' ' + self.dob
