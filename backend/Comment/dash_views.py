from django.shortcuts import render
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView

from Comment.forms import CommentForm, DashCommentForm
from Comment.models import Comment
from Comment.serializers import CommentSerializer
from Food.models import Food
from Restaurant.models import Restaurant


class CommentAPIList(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        foods = Food.objects.filter(restaurant__owner_account=request.user)
        uuids = [item.uuid for item in foods]
        res = Restaurant.objects.get(owner_account=request.user)
        uuids.append(res.uuid)
        comments = Comment.objects.filter(comment_for__in=uuids,parent=None).order_by('-published_at')
        serializer = CommentSerializer(comments, many=True)
        return Response({'comments': serializer.data})

    def post(self, request):
        data = request.data
        form = DashCommentForm(data)
        if form.is_valid():
            instance = form.save(commit=False)
            instance.comment_from = request.user
            instance.save()
            serializer = CommentSerializer(instance)
            return Response(serializer.data)
        else:
            print(form.errors)
            return Response(status=status.HTTP_400_BAD_REQUEST)
