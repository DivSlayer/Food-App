import os
from functools import reduce

from django.contrib.auth import authenticate, login
from django.http import HttpResponse
from django.shortcuts import render
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView

import Transaction
from Account.api_views import get_tokens_for_user
from Account.forms import AccountAuthentication
from Category.models import Category
from Food.models import Food, SizeModel
from Food.serializers import FoodSerializer, SizeSerializer
from Restaurant.models import Restaurant
from Transaction.models import TransactionModel


class GetToken(APIView):
    def post(self, request):
        form = AccountAuthentication(request.data)
        if form.is_valid():
            print('form is valid')
            phone = form.cleaned_data['phone']
            password = form.cleaned_data["password"]
            user = authenticate(phone=phone, password=password)
            if user and user.is_restaurant:
                login(request, user)
                return Response(get_tokens_for_user(user))
            return Response(
                {"error": "Something went wrong!"},
                status=status.HTTP_400_BAD_REQUEST
            )
        else:
            return Response(
                {'error': form.errors},
                status=status.HTTP_400_BAD_REQUEST
            )


class LoginAPIView(APIView):
    def post(self, request):
        form = AccountAuthentication(request.data)
        if form.is_valid():
            phone = form.cleaned_data['phone']
            password = form.cleaned_data["password"]
            instance = form.save(commit=False)
            if not instance.is_restaurant:
                return Response(
                    {"error": "Something went wrong!"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            user = authenticate(phone=phone, password=password)
            if user:
                login(request, user)
                return Response(get_tokens_for_user(user))
            return Response(
                {"error": "Something went wrong!"},
                status=status.HTTP_400_BAD_REQUEST
            )
        else:
            return Response(
                {'error': form.errors},
                status=status.HTTP_400_BAD_REQUEST
            )


def test(request):
    transaction = TransactionModel.objects.all()
    new_list = list(transaction)
    phone = '09214834536'
    orders = transaction.orders.all()
    add_check = reduce(lambda x, y: x or y.created_by.phone == phone or y.restaurant.owner_account.phone == phone,
                       list(orders), False)
    return HttpResponse(add_check)


def check(request):
    return HttpResponse(True, content_type='application/json')


class ListFoodApiView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        try:
            cat_uuid = request.query_params.get('category', None)
            foods = Food.objects.filter(restaurant__owner_account__phone=request.user.phone)
            if cat_uuid is not None:
                foods = foods.filter(category__uuid__in=[cat_uuid])
            food_data = FoodSerializer(foods, many=True).data
            # Fetch restaurant data
            return Response({'foods': food_data})
        except Exception as e:
            # raise e
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        serializer = FoodSerializer(data=request.data)
        image_file = request.FILES.get('image', None)

        # Validate and save the serializer
        if serializer.is_valid():
            cat = request.data['category']
            cat = Category.objects.get(pk=cat)
            res = Restaurant.objects.get(owner_account__phone=request.user.phone)
            # Create the Food instance
            food = Food(**serializer.validated_data, category=cat, restaurant=res)
            food.save()

            # Handle image file if present
            if image_file is not None:
                # Handle previous image removal
                if food.image:  # Check if food has an existing image before trying to remove it
                    try:
                        if os.path.isfile(food.image.path):
                            os.remove(food.image.path)
                    except Exception as e:
                        print(f"Error removing file: {e}")

                # Save the new image
                food.image = image_file
                food.save()  # Save the instance again with the new image

            # Return the response with serialized data
            return Response(FoodSerializer(food).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SingleFoodApiView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, uuid):
        try:
            food = Food.objects.get(uuid=uuid)
            if food.restaurant.owner_account == request.user:
                serializer = FoodSerializer(food, context={
                    'big': True,
                })
                return Response({"foods": [serializer.data]})
            return Response({'error': "You are not allowed"}, status=status.HTTP_401_UNAUTHORIZED)
        except Food.DoesNotExist as e:
            return Response('غذا پیدا نشد!', status=status.HTTP_404_NOT_FOUND)

    def put(self, request, uuid):
        if uuid is not None:
            try:
                food = Food.objects.get(uuid=uuid)
                serializer = FoodSerializer(food, data=request.data, partial=True)
                image_file = request.FILES.get('image', None)
                cat = request.data.get('category', None)
                if image_file is not None:
                    if os.path.isfile(food.image.path):
                        os.remove(food.image.path)
                    food.image = image_file
                    food.save()
                if serializer.is_valid():
                    food = serializer.save()
                    if cat is not None:
                        cat = Category.objects.get(pk=cat)
                        food.category = cat
                        food.save()
                    return Response(serializer.data)
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            except Food.DoesNotExist:
                return Response({'error': 'Food not found!'}, status=status.HTTP_404_NOT_FOUND)
        return Response(status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, uuid):
        if not uuid:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        try:
            food = obj = Food.objects.get(uuid=uuid)
        except Food.DoesNotExist:
            return Response({'error': 'Food not found!'}, status=status.HTTP_404_NOT_FOUND)

        if food.restaurant.owner_account != request.user:
            return Response({'error': 'food is not yours to delete'}, status=status.HTTP_401_UNAUTHORIZED)
        obj.delete()
        return Response({'result': 'deleted'})


class SizeApiView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, uuid):
        try:
            food = Food.objects.get(uuid=uuid)
            not_related = food.restaurant.owner_account.phone != request.user.phone
            if not_related:
                return Response({'error': "Food doesn't belong to you!"}, status=status.HTTP_403_FORBIDDEN)
            data = request.data.copy()
            data['food'] = food.pk  # Modify the price field
            serializer = SizeSerializer(data=data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response({'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
        except Food.DoesNotExist as e:
            return Response({'error': 'Food was not found!'}, status=status.HTTP_404_NOT_FOUND)


    def put(self, request,uuid):
        try:
            size = SizeModel.objects.get(uuid=uuid)
            not_related = size.food.restaurant.owner_account.phone != request.user.phone
            if not_related:
                return Response({'error': "Size doesn't belong to you!"}, status=status.HTTP_403_FORBIDDEN)
            serializer = SizeSerializer(size, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)

            return Response({'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
        except SizeModel.DoesNotExist as e:
            return Response({'error': 'Size was not found!'}, status=status.HTTP_404_NOT_FOUND)

    def delete(self, request, uuid):
        try:
            size = SizeModel.objects.get(uuid=uuid)
            not_related = size.food.restaurant.owner_account.phone != request.user.phone
            if not_related:
                return Response({'error': "Size doesn't belong to you!"}, status=status.HTTP_403_FORBIDDEN)
            size.delete()
            return Response({'result': 'deleted'})
        except SizeModel.DoesNotExist as e:
            return Response({'error': 'Size was not found!'}, status=status.HTTP_404_NOT_FOUND)