from rest_framework import serializers
from Account.models import Account
from Address.models import Address
from Address.serializers import AddressSerializer
from food_backend.env import Env

SERVER = Env().get_server()


class TeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account


class AccountSerializer(serializers.ModelSerializer):
    profile_image = serializers.SerializerMethodField('get_profile_image')
    addresses = serializers.SerializerMethodField('get_addresses')

    class Meta:
        model = Account
        fields = [
            'uuid',
            'phone',
            'first_name',
            'last_name',
            "profile_image",
            "addresses"
        ]

    def get_addresses(self, account):
        big = self.context.get('big',True)
        if big:
            addresses = Address.objects.filter(owner_account=account)
            print('addresses', addresses)
            return AddressSerializer(addresses, many=True).data
        return []

    def get_profile_image(self, account):
        return SERVER + account.profile_image.url if account.profile_image else None


class AccountUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = [
            'phone',
            'first_name',
            'last_name',
        ]
