from django.contrib.auth.base_user import BaseUserManager, AbstractBaseUser
from django.contrib.auth.models import Group, PermissionsMixin
from django.db import models
from django.db.models.signals import pre_save
from django.dispatch import receiver
from Utils.functions import generate_qrcode_svg, get_uuid


# Create your models here.


class MyAccountManager(BaseUserManager):
    def create_user(self, phone, first_name, last_name, password=None):
        if not phone:
            raise ValueError("Users must have a phone number")
        if not first_name:
            raise ValueError("Users must have a first name")
        if not last_name:
            raise ValueError("Users must have a last name")
        if not password:
            raise ValueError("Users must have passwords")
        user = self.model(phone=phone, first_name=first_name, last_name=last_name)
        user.set_password(password)
        user.save(using=self._db)
        group = Group.objects.get_or_create(name='Default')
        user.groups.add(Group.objects.get(name='Default'))
        return user

    def create_superuser(self, phone, first_name, last_name, password):
        user = self.create_user(
            phone=phone,
            first_name=first_name,
            last_name=last_name,
            password=password,
        )
        user.is_admin = True
        user.is_superuser = True
        user.is_staff = True
        user.is_active = True
        user.is_teacher = False
        user.is_representative = False
        user.is_verified = True
        user.is_restaurant = False
        user.save(using=self._db)
        return user


def get_profile_directory(account, filepath):
    ext = filepath.split('.')[-1]
    return f'profiles/{account.phone}/profile.jpg'


def get_qrCode_directory(account, filepath):
    ext = filepath.split('.')[-1]
    return f'profiles/{account.phone}/qrcode.svg'


class Account(AbstractBaseUser, PermissionsMixin):
    uuid = models.CharField(max_length=15, default=get_uuid, unique=True)
    phone = models.CharField(max_length=12, unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100, null=True, blank=True)
    profile_image = models.ImageField(upload_to=get_profile_directory, default='profiles/default-profile.png')
    created_at = models.DateTimeField(auto_now=False, auto_now_add=True)
    last_login = models.DateTimeField(auto_now=True)
    is_admin = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_representative = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    is_restaurant = models.BooleanField(default=False)
    qrcode = models.TextField(blank=True)
    USERNAME_FIELD = "phone"
    REQUIRED_FIELDS = ["first_name", "last_name"]
    objects = MyAccountManager()

    def __str__(self) -> str:
        return self.first_name + " " + self.last_name + self.uuid


@receiver(pre_save, sender=Account)
def my_callback(sender, instance, *args, **kwargs):
    instance.qrcode = generate_qrcode_svg(instance.uuid)
