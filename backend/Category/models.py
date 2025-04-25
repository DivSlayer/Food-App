from django.core.validators import FileExtensionValidator
from django.db import models

from Account.models import Account
from Utils.functions import get_uuid


def get_category_directory(cat, filepath):
    ext = filepath.split('.')[-1]
    return f'Categories/{cat.title}-{cat.uuid}/image.svg'


class Category(models.Model):
    class Meta:
        verbose_name_plural = "Categories"

    uuid = models.CharField(unique=True, default=get_uuid, max_length=15, editable=False)
    title = models.CharField(max_length=20)
    icon = models.FileField(upload_to=get_category_directory,
                            validators=[FileExtensionValidator(allowed_extensions=['svg'])])
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    created_by = models.ForeignKey(Account, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return self.title + "-" + self.uuid
