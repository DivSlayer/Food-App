from django.db import models

from Account.models import Account
from Utils.functions import get_uuid


class Address(models.Model):
    uuid = models.CharField(primary_key=True, max_length=15, unique=True, default=get_uuid, editable=False)
    title = models.CharField(max_length=200)
    name = models.CharField(max_length=200)
    phone = models.CharField(max_length=15)
    latitude = models.TextField()
    longitude = models.TextField()
    brief_address = models.TextField()
    owner_account = models.ForeignKey(Account, on_delete=models.CASCADE,null=True)
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    edited_at = models.DateTimeField(auto_now=True, auto_now_add=False)

    def __str__(self):
        return self.owner_account.phone + " " + self.brief_address
