# Generated by Django 5.0.7 on 2025-03-17 19:23

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('Transaction', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='ordermodel',
            name='total_time',
        ),
    ]
