import json

from django.http import Http404
from django.shortcuts import render, get_list_or_404
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from Food.models import Food
from Food.serializers import FoodSerializer
from Restaurant.models import Restaurant
from Restaurant.serializers import RestaurantSerializer


class SingleFoodApiView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, uuid):
        try:
            food = Food.objects.get(uuid=uuid)
            serializer = FoodSerializer(food, context={
                'big': True,
            })
            return Response({"foods": [serializer.data]})
        except Food.DoesNotExist as e:
            return Response('غذا پیدا نشد!', status=status.HTTP_404_NOT_FOUND)


class CheckFoodsExistence(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        data = request.data
        uuids_list = data.get('uuids')
        print(data)

        # Assuming uuids_list is already a list, no need to parse it again
        if isinstance(uuids_list, str):
            uuids_list = json.loads(uuids_list)

        exist_foods = []
        for uuid in uuids_list:
            try:
                print(uuid)
                food = get_list_or_404(Food, uuid=uuid)[0]
                exist_foods.append(food)
            except Http404:
                continue
        print(exist_foods)
        return Response({'foods': FoodSerializer(exist_foods, many=True).data})


class ListFoodApiView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        try:
            cat_uuid = request.query_params.get('category', None)
            foods = Food.objects.all()
            if cat_uuid is not None:
                foods = foods.filter(category__uuid__in=[cat_uuid])
            food_data = FoodSerializer(foods, many=True).data
            # Fetch restaurant data
            return Response({'foods': food_data})
        except Exception as e:
            # raise e
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
