from rest_framework import serializers

from Comment.models import Comment
from Food.models import Food
from Food.serializers import FoodSerializer
from Restaurant.models import Restaurant
from Restaurant.serializers import RestaurantSerializer
from Search.engine import SearchEngine
from food_backend.env import Env

# Assuming you have a RestaurantSerializer and FoodSerializer defined elsewhere
# from .serializers import RestaurantSerializer, FoodSerializer
SERVER = Env().get_server()
class ReplySerializer(serializers.ModelSerializer):
    comment_from = serializers.SerializerMethodField()
    replies = serializers.SerializerMethodField()  # Add this to include nested replies

    class Meta:
        model = Comment
        fields = ['uuid', 'content', 'published_at', 'isVerified', 'rating', 'comment_from', 'replies']

    def get_comment_from(self, obj):
        return {
            'first_name': obj.comment_from.first_name,
            'last_name': obj.comment_from.last_name,
            'profile': SERVER + obj.comment_from.profile_image.url,
        }

    def get_replies(self, obj):
        # Fetch replies to this reply in the desired order
        replies = obj.replies.filter(parent=obj).order_by('-published_at')  # Filter replies to this comment
        return ReplySerializer(replies, many=True).data  # Serialize the replies


class CommentSerializer(serializers.ModelSerializer):
    comment_for = serializers.SerializerMethodField()
    comment_from = serializers.SerializerMethodField()
    replies = serializers.SerializerMethodField()  # Use this to get replies

    class Meta:
        model = Comment
        fields = [
            'uuid',
            'content',
            'comment_for',
            'comment_from',
            'published_at',
            'isVerified',
            'rating',
            'replies',
        ]

    def get_comment_for(self, obj):
        if obj.comment_from is not None:
            reses = RestaurantSerializer(Restaurant.objects.all(), many=True, context={'big': False}).data
            foods = FoodSerializer(Food.objects.all(), many=True).data
            found_res = SearchEngine(obj.comment_for, 'uuid', reses).search()
            if len(found_res) > 0:
                return {'restaurant': found_res[0]}
            found_food = SearchEngine(obj.comment_for, 'uuid', foods).search()
            if len(found_food) > 0:
                return {"food": found_food[0]}
        return None

    def get_comment_from(self, obj):
        return {
            'first_name': obj.comment_from.first_name,
            'last_name': obj.comment_from.last_name,
            'profile_image': SERVER + obj.comment_from.profile_image.url,
        }

    def get_replies(self, obj):
        # Fetch replies in the desired order
        replies = obj.replies.filter(parent=obj).order_by('-published_at')  # Get direct replies to this comment
        return ReplySerializer(replies, many=True).data  # Serialize the replies