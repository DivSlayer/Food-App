from django.shortcuts import render
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView

from Comment.forms import CommentForm
from Comment.models import Comment
from Comment.serializers import CommentSerializer
from Food.models import Food
from Food.serializers import FoodSerializer
from Restaurant.models import Restaurant
from Restaurant.serializers import RestaurantSerializer
from Search.engine import SearchEngine


class CommentAPIList(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, uuid):
        food = Food.objects.filter(uuid=uuid)
        comment_for = food.first() if len(food) > 0 else None
        rese = Restaurant.objects.filter(uuid=uuid)
        comment_for = rese.first() if len(rese) > 0 else comment_for
        if comment_for is not None:
            comments = Comment.objects.filter(comment_for=comment_for.uuid).order_by('-published_at')
            serializer = CommentSerializer(comments, many=True)
            return Response({'comments': serializer.data})
        return Response({'message': 'No comments found'}, status=status.HTTP_404_NOT_FOUND)

    def post(self, request, uuid):
        data = request.data
        form = CommentForm(data)
        if form.is_valid():
            instance = form.save(commit=False)
            instance.comment_from = request.user
            instance.comment_for = uuid
            instance.save()
            serializer = CommentSerializer(instance)
            return Response({'comments': [serializer.data]})
        else:
            print(form.errors)
            return Response(status=status.HTTP_400_BAD_REQUEST)
