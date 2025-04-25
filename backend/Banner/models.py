from django.db import models
from ckeditor.fields import RichTextField
from Food.models import Food
from Utils.functions import get_uuid


class Banner(models.Model):
    uuid = models.CharField(max_length=15, default=get_uuid, unique=True, primary_key=True)
    content = RichTextField()
    for_food = models.ForeignKey(Food, on_delete=models.CASCADE)
    views = models.IntegerField()
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)

    def __str__(self):
        return self.uuid
