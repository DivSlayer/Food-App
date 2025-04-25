import logging
import os
import shutil

from django.core.validators import FileExtensionValidator
from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver

from Restaurant.models import Restaurant
from Utils.functions import get_uuid


# Create your models here.

def get_instruction_image(instruction, file_path):
    ext = file_path.split('.')[-1]
    return f'Instructions/{instruction.name}-{instruction.uuid}/image.{ext}'


class Instruction(models.Model):
    uuid = models.CharField(unique=True, max_length=15, default=get_uuid, editable=False)
    name = models.CharField(max_length=50)
    image = models.FileField(upload_to=get_instruction_image, validators=[
        FileExtensionValidator(allowed_extensions=['svg', 'jpg', 'png']),
    ])
    price = models.IntegerField()
    stack = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    edited_at = models.DateTimeField(auto_now=True, auto_now_add=False)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@receiver(post_delete, sender=Instruction)
def post_delete_handler(sender, instance, **kwargs):
    if instance.image:
        try:
            image_path = instance.image.path
            # Check if the image file exists before attempting to delete it
            if os.path.isfile(image_path):
                os.remove(image_path)
                logger.info(f"Deleted image file: {image_path}")

                # Get the directory path from the image path
            folder = os.path.dirname(image_path)
            folder = os.path.join(os.getcwd(), folder)

            # Check if the folder is not the current working directory and exists
            if folder != os.getcwd() and os.path.isdir(folder):
                shutil.rmtree(folder)
                logger.info(f"Deleted directory: {folder}")

        except OSError as e:
            logger.error(f"Error deleting file or directory: {e}")
        except Exception as e:
            logger.error(f"An unexpected error occurred: {e}")
