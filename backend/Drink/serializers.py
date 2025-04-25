from rest_framework import serializers

from Drink.models import Drink
from food_backend.env import Env

SERVER = Env().get_server()


class DrinkSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField('get_image')

    class Meta:
        model = Drink
        fields = [
            "uuid",
            "name",
            "details",
            "image",
            'price'
        ]

    def get_image(self, drink):
        return SERVER + drink.image.url
