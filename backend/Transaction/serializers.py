from datetime import datetime

from rest_framework import serializers

from Account.models import Account
from Account.serializers import AccountSerializer
from Extras.serializers import ExtraSerializer
from Food.models import Food
from Food.serializers import FoodSerializer, SizeSerializer
from Instruction.serializers import InstructionSerializer
from Restaurant.models import Restaurant
from Transaction.models import TransactionModel, OrderModel, OrderItemExtraOption, OrderItemInstructionOption
from food_backend.env import Env

SERVER = Env().get_server()


class OrderItemExtraOptionSerializer(serializers.ModelSerializer):
    uuid = serializers.SerializerMethodField('get_uuid')
    name = serializers.SerializerMethodField('get_name')
    icon = serializers.SerializerMethodField('get_icon')
    price = serializers.SerializerMethodField('get_price')

    class Meta:
        model = OrderItemExtraOption
        fields = ['quantity', 'uuid', 'name', 'icon', 'price']

    def get_uuid(self, obj):
        return obj.extra_option.uuid

    def get_name(self, obj):
        return obj.extra_option.name

    def get_icon(self, obj):
        return SERVER + obj.extra_option.icon.url

    def get_price(self, obj):
        return obj.extra_option.price


class OrderItemInstructionOptionSerializer(serializers.ModelSerializer):
    uuid = serializers.SerializerMethodField('get_uuid')
    name = serializers.SerializerMethodField('get_name')
    image = serializers.SerializerMethodField('get_image')
    price = serializers.SerializerMethodField('get_price')

    class Meta:
        model = OrderItemInstructionOption
        fields = ['quantity', 'uuid', 'name', 'image', 'price', 'image']

    def get_uuid(self, obj):
        return obj.instruction_option.uuid

    def get_name(self, obj):
        return obj.instruction_option.name

    def get_image(self, obj):
        return SERVER + obj.instruction_option.image.url

    def get_price(self, obj):
        return obj.instruction_option.price


class OrderSerializer(serializers.ModelSerializer):
    food = serializers.SerializerMethodField('get_food')  # Nested serializer for food
    food_size = serializers.SerializerMethodField('get_food_size')  # Nested serializer for food
    extras = OrderItemExtraOptionSerializer(source='orderitemextraoption_set', many=True)
    instructions = OrderItemInstructionOptionSerializer(source='orderiteminstructionoption_set', many=True)
    restaurant = serializers.SerializerMethodField('get_restaurant')
    food_uuid = serializers.SerializerMethodField('get_food_uuid')

    class Meta:
        model = OrderModel
        fields = ['uuid', 'food', 'status', 'created_time',
                  'restaurant', "food_uuid", 'quantity', 'food_size', 'extras',
                  'instructions']  # Include fields you want to expose

    def get_food(self, order):
        big = self.context.get('big', False)
        return FoodSerializer(order.food, context={'big': big}).data

    def get_food_uuid(self, order):
        return order.food.uuid

    def get_food_size(self, order):
        return SizeSerializer(order.food_size).data

    def get_restaurant(self, transaction):
        return transaction.restaurant.uuid

    def create(self, validated_data):
        food_data = validated_data.pop('food')
        food, created = (Food.objects.get_or_create(**food_data))
        order = OrderModel.objects.create(food=food, **validated_data)
        return order


class TransactionSerializer(serializers.ModelSerializer):
    orders = serializers.SerializerMethodField("get_orders")
    created_by = serializers.SerializerMethodField('get_created_by')
    client_name = serializers.SerializerMethodField('get_client_name')
    address = serializers.SerializerMethodField('get_address')

    class Meta:
        model = TransactionModel
        fields = ['serial', 'orders', 'paid_time', 'total_duration', 'total_price',
                  'status', 'created_by', 'delivery_code', 'address',
                  'client_name', 'changed_at']

    def get_created_by(self, transaction):
        return transaction.created_by.uuid

    def get_client_name(self, transaction):
        return f'{transaction.created_by.first_name} {transaction.created_by.last_name}'

    def get_address(self, transaction):
        return {
            'latitude': transaction.address.latitude,
            'longitude': transaction.address.longitude,
            'brief_address': transaction.address.brief_address,
            'client_phone': transaction.address.phone,
        }

    def get_orders(self, transaction):
        big = self.context.get('big', False)
        user = self.context.get('user')
        if user and user.is_restaurant:
            orders = OrderModel.objects.filter(transaction=transaction, restaurant__owner_account__phone=user.phone)
            serialized = OrderSerializer(orders, many=True, context={'big': big})
            return serialized.data
        orders = OrderModel.objects.filter(transaction=transaction)
        orders = OrderSerializer(orders, many=True, context={'big': big})
        return orders.data

    def create(self, validated_data):
        orders_data = validated_data.pop('orders')
        created_by_data = validated_data.pop('created_by')
        restaurant_data = validated_data.pop('restaurant')
        created_by = Account.objects.get(uuid=created_by_data)
        restaurant = Restaurant.objects.get(uuid=restaurant_data)

        # Create the transaction instance
        transaction = TransactionModel.objects.create(created_by=created_by, restaurant=restaurant, **validated_data)

        # Create and add each order to the transaction
        for order_data in orders_data:
            food_data = order_data.pop('food')
            food, created = Food.objects.get_or_create(**food_data)
            order = OrderModel.objects.create(food=food, **order_data)
            transaction.orders.add(order)

        return transaction
