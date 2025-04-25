from django.db import models

from Account.models import Account
from Utils.functions import get_uuid
from django_jalali.db.models import models as jmodels


class Comment(models.Model):
    uuid = models.CharField(primary_key=True, unique=True, max_length=15, default=get_uuid)
    content = models.TextField()
    comment_for = models.CharField(max_length=15, null=True, blank=True)
    comment_from = models.ForeignKey(Account, on_delete=models.CASCADE)
    published_at = jmodels.DateTimeField(auto_now=False, auto_now_add=True, editable=True)
    isVerified = models.BooleanField(default=True)
    rating = models.FloatField(null=True, blank=True)
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='replies')

    def __str__(self):
        return f"Comment from: {self.comment_from}, for: {self.comment_for}"
