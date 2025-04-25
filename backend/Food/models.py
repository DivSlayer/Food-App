import logging
import os
import shutil

from django.core.validators import FileExtensionValidator, MaxValueValidator
from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver

from Category.models import Category
from Extras.models import Extra
from Instruction.models import Instruction
from Restaurant.models import Restaurant
from Utils.functions import get_uuid


def get_food_directory(food, filepath):
    ext = filepath.split('.')[-1]
    return f'Foods/{food.name}-{food.uuid}/image.{ext}'


class Food(models.Model):
    uuid = models.CharField(max_length=15, default=get_uuid, unique=True, editable=False)
    name = models.CharField(max_length=50)
    details = models.TextField()
    image = models.ImageField(upload_to=get_food_directory,
                              validators=[FileExtensionValidator(allowed_extensions=['png', 'jpg'])])
    preparation_time = models.IntegerField(help_text="Write in minutes")
    rating = models.CharField(max_length=5, default="4.3")
    stack = models.IntegerField(default=100)
    category = models.ForeignKey(Category, on_delete=models.DO_NOTHING)
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    edited_at = models.DateTimeField(auto_now=True, auto_now_add=False)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name + " " + self.uuid


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@receiver(post_delete, sender=Food)
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


class SizeModel(models.Model):
    uuid = models.CharField(max_length=15, default=get_uuid, unique=True, editable=False)
    name = models.CharField(max_length=255)
    details = models.TextField()
    price = models.IntegerField()
    food = models.ForeignKey(Food, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name + " "+ self.uuid
