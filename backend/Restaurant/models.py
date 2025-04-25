from django.core.validators import FileExtensionValidator
from django.db import models

from Account.models import Account
from Drink.models import Drink
from Utils.functions import get_uuid


def get_restaurant_directory(restaurant, filepath):
    ext = filepath.split('.')[-1]
    return f'Restaurants/{restaurant.name}-{restaurant.uuid}/image.{ext}'


def get_restaurant_logo(restaurant, filepath):
    ext = filepath.split('.')[-1]
    return f'Restaurants/{restaurant.name}-{restaurant.uuid}/logo.{ext}'


class Restaurant(models.Model):
    uuid = models.CharField(max_length=15, default=get_uuid, unique=True, editable=False)
    name = models.CharField(max_length=50)
    drinks = models.ManyToManyField(Drink, blank=True)
    image = models.ImageField(upload_to=get_restaurant_directory,
                              validators=[FileExtensionValidator(allowed_extensions=['jpg', 'png'])])
    logo = models.ImageField(upload_to=get_restaurant_logo,
                             validators=[FileExtensionValidator(allowed_extensions=['jpg', 'png', 'svg'])])
    coverage = models.JSONField(default=list, blank=True, null=True)
    owner_account = models.ForeignKey(Account, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name + " " + self.uuid


    def save(self, *args, **kwargs):
        if self.coverage is None:
            self.coverage = []
        super(Restaurant, self).save(*args, **kwargs)