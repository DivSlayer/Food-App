import math
from functools import reduce
from rest_framework import serializers

from Account.models import Account
from Address.models import Address
from Address.serializers import AddressSerializer
from Comment.models import Comment
from Extras.models import Extra
from Extras.serializers import ExtraSerializer
from Instruction.models import Instruction
from Instruction.serializers import InstructionSerializer
from Restaurant.models import Restaurant
from food_backend.env import Env

SERVER = Env().get_server()


class RestaurantSerializer(serializers.ModelSerializer):
    addresses = serializers.SerializerMethodField('get_addresses')
    image = serializers.SerializerMethodField('get_image')
    logo = serializers.SerializerMethodField('get_logo')
    instructions = serializers.SerializerMethodField('get_instructions')
    extras = serializers.SerializerMethodField('get_extras')
    comments_count = serializers.SerializerMethodField('get_comments_count')
    rating = serializers.SerializerMethodField('get_rating')

    class Meta:
        model = Restaurant
        fields = [
            "uuid",
            "name",
            "image",
            "logo",
            "instructions",
            "extras",
            'comments_count',
            'rating',
            'coverage',
            'addresses'
        ]

    def get_image(self, restaurant):
        return SERVER + restaurant.image.url

    def get_logo(self, restaurant):
        return SERVER + restaurant.logo.url

    def get_comments_count(self, res):
        comments = Comment.objects.filter(comment_for=res.uuid)
        return len(comments)

    def get_rating(self, res):
        comments = Comment.objects.filter(comment_for=res.uuid)
        integer_values = [obj.rating for obj in comments]
        total_sum = reduce(lambda x, y: x + y, integer_values, 0)
        mean_val = (math.ceil((total_sum / len(comments)) * 10) / 10) if len(comments) > 0 else 0
        return str(mean_val)

    def get_instructions(self, restaurant):
        small = self.context.get('small', False)
        if not small:
            instructions = Instruction.objects.filter(restaurant=restaurant)
            return InstructionSerializer(instructions, many=True).data
        return []

    def get_extras(self, restaurant):
        small = self.context.get('small', False)
        if not small:
            instructions = Extra.objects.filter(restaurant=restaurant)
            return ExtraSerializer(instructions, many=True).data
        return []

    def get_addresses(self, restaurant):
        addresses = Address.objects.filter(owner_account=restaurant.owner_account)
        return AddressSerializer(addresses, many=True).data
