import math
from functools import reduce

from rest_framework import serializers

from Comment.models import Comment
from Extras.serializers import ExtraSerializer
from Food.models import Food, SizeModel
from Instruction.serializers import InstructionSerializer
from Restaurant.serializers import RestaurantSerializer
from food_backend.env import Env

SERVER = Env().get_server()


class SizeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SizeModel
        fields = "__all__"


class FoodSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField('get_image')
    sizes = serializers.SerializerMethodField('get_sizes')
    restaurant_info = serializers.SerializerMethodField('get_restaurant_info')
    restaurant = serializers.SerializerMethodField('get_restaurant')
    comments_count = serializers.SerializerMethodField('get_comments_count')
    rating = serializers.SerializerMethodField('get_rating')
    rating_count = serializers.SerializerMethodField('get_rating_count')
    category = serializers.SerializerMethodField('get_category')

    class Meta:
        model = Food
        fields = [
            "uuid",
            "name",
            'image',
            "details",
            "preparation_time",
            "rating",
            "sizes",
            "restaurant_info",
            "restaurant",
            'comments_count',
            'rating_count',
            "category",
        ]

    def get_image(self, food):
        if food.image and food.image is None:
            return None
        else:
            return SERVER + food.image.url

    def get_comments_count(self, res):
        full_content = self.context.get('big', True)
        if full_content:
            comments = Comment.objects.filter(comment_for=res.uuid)
            return len(comments)
        return 0

    def get_rating(self, res):
        full_content = self.context.get('big', True)
        if full_content:
            comments = Comment.objects.filter(comment_for=res.uuid, parent=None)
            integer_values = [obj.rating for obj in comments]
            total_sum = reduce(lambda x, y: x + y, integer_values, 0)
            mean_val = (math.ceil((total_sum / len(comments)) * 10) / 10) if len(comments) > 0 else 0
            return str(mean_val)
        return '0'

    def get_rating_count(self, res):
        full_content = self.context.get('big', True)
        if full_content:
            comments = Comment.objects.filter(comment_for=res.uuid)
            length = [obj.rating for obj in comments if obj.rating != 0]
            return len(length)
        return 0

    def get_sizes(self, food):
        full_content = self.context.get('big', True)
        if full_content:
            sizes = SizeModel.objects.filter(food=food)
            return SizeSerializer(sizes, many=True).data
        return []

    def get_restaurant(self, food):
        full_content = self.context.get('big', False)
        if full_content:
            return RestaurantSerializer(food.restaurant).data
        return None

    def get_restaurant_info(self, food):
        res_dict = {
            "uuid": food.restaurant.uuid,
            "name": food.restaurant.name,
            "image": (SERVER + food.restaurant.image.url) if food.restaurant.image is not None else None,
            # Or add a model field for initials
            "logo": (SERVER + food.restaurant.logo.url) if food.restaurant.logo is not None else None
            # Or add a model field for initials
        }
        print(res_dict)
        return res_dict

    def get_category(self, food):
        return food.category.uuid
