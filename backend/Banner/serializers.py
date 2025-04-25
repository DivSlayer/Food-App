from rest_framework import serializers

from Banner.models import Banner
from Food.serializers import FoodSerializer


class BannerSerializer(serializers.ModelSerializer):
    food = serializers.SerializerMethodField('get_food')

    class Meta:
        model = Banner
        fields = [
            'uuid',
            'content',
            'food'
        ]

    def get_food(self, banner):
        food = banner.for_food
        serializer = FoodSerializer(food)
        return serializer.data
