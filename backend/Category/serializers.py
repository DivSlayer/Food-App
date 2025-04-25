from rest_framework import serializers

from Category.models import Category
from food_backend.env import Env

SERVER = Env().get_server()


class CategorySerializer(serializers.ModelSerializer):
    icon = serializers.SerializerMethodField('get_icon')

    class Meta:
        model = Category
        fields = [
            "pk",
            "uuid",
            "title",
            "icon",
        ]

    def get_icon(self, cat):
        return SERVER + cat.icon.url
