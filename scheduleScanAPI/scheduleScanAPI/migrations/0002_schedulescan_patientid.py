# Generated by Django 4.1.6 on 2023-03-23 22:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scheduleScanAPI', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='schedulescan',
            name='patientID',
            field=models.CharField(default='', max_length=255),
        ),
    ]