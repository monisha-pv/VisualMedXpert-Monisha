# Generated by Django 4.1.3 on 2023-04-15 02:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0004_patient_nhsno'),
    ]

    operations = [
        migrations.AddField(
            model_name='patient',
            name='gender',
            field=models.CharField(default='Female', max_length=100),
        ),
    ]