# Generated by Django 5.0.7 on 2025-04-20 12:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Transaction', '0005_transactionmodel_address'),
    ]

    operations = [
        migrations.AlterField(
            model_name='transactionmodel',
            name='changed_at',
            field=models.DateTimeField(),
        ),
        migrations.AlterField(
            model_name='transactionmodel',
            name='status',
            field=models.CharField(choices=[('PE', 'Pending'), ('CO', 'Completed'), ('CI', 'Completing'), ('CA', 'Canceled'), ('AC', 'Accepted'), ('DE', 'Declined')], max_length=2),
        ),
    ]
