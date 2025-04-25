import os

from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver

from Utils.functions import get_uuid


def get_drink_directory(drink, filepath):
    ext = filepath.split('.')[-1]
    return f'Drinks/{drink.name}-{drink.uuid}/image.jpg'


class Drink(models.Model):
    uuid = models.CharField(max_length=15, default=get_uuid, editable=False, unique=True)
    name = models.CharField(max_length=50)
    details = models.TextField()
    image = models.ImageField(upload_to=get_drink_directory)
    price = models.CharField(max_length=10)
    stack = models.IntegerField()
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    edited_at = models.DateTimeField(auto_now=True, auto_now_add=False)

    def __str__(self):
        return self.name + " " + self.uuid


@receiver(post_delete, sender=Drink)
def post_delete_handler(sender, instance, **kwargs):
    if instance.file:
        if os.path.isfile(instance.image.path):
            os.remove(instance.image.path)
