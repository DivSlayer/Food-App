import os
import re
import subprocess
import time
from datetime import timedelta, datetime

import pytz
from django.core.management.base import BaseCommand
from django.utils import timezone

from Transaction.models import TransactionModel


class Command(BaseCommand):
    help = 'Process transactions in the background'

    def handle(self, *args, **options):
        self.stdout.write("Starting transaction processing worker...")
        while True:
            transactions = TransactionModel.objects.filter(status='AC')
            for transaction in transactions:
                delivery_due = transaction.changed_at + timedelta(minutes=transaction.total_duration)
                now = timezone.now()
                passed = now >= delivery_due
                if passed:
                    transaction.status = 'CI'
                    transaction.save()
            time.sleep(5)


    def process_job(self, job:TransactionModel):
        pass
