from rest_framework import serializers

from Address.models import Address


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = [
            'uuid',
            'title',
            'name',
            'phone',
            'latitude',
            'longitude',
            'brief_address',
            'created_at',
            'edited_at'
        ]
