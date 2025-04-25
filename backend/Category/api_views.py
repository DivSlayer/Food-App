from django.shortcuts import render
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from Category.models import Category
from Category.serializers import CategorySerializer


# Create your views here.
class ListApi(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        is_res = request.user.is_restaurant
        if is_res:
            cats = Category.objects.filter(created_by=request.user)
        else:
            cats = Category.objects.all()
        return Response({"categories": CategorySerializer(cats, many=True).data})


class SingleCategoryAPI(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def put(self, request, uuid):
        try:
            category = Category.objects.get(uuid=uuid)
            serializer = CategorySerializer(category, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'categorise': serializer.data})
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Category.DoesNotExist:
            return Response({'error': 'Cat does not exist'}, status=status.HTTP_404_NOT_FOUND)

    def delete(self, request, uuid):
        try:
            cat = Category.objects.get(uuid=uuid)
            is_related = cat.created_by == request.user and request.user.is_restaurant
            if is_related:
                cat.delete()
                return Response({'result': 'deleted'})
            return Response({'error': 'category is not yours to delete'}, status=status.HTTP_401_UNAUTHORIZED)
        except Category.DoesNotExist:
            return Response({'error': 'category not found!'}, status=status.HTTP_404_NOT_FOUND)
