import os

from rest_framework.views import APIView
from rest_framework import permissions
from rest_framework.response import Response
from rest_framework import status

from Restaurant.models import Restaurant
from Restaurant.serializers import RestaurantSerializer


class RestaurantAPIView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        if request.user.is_restaurant:
            res = Restaurant.objects.filter(owner_account__phone=request.user.phone).first()
            serializer = RestaurantSerializer(res)
            return Response(serializer.data)
        return Response(status=status.HTTP_403_FORBIDDEN)

    def put(self, request):
        if request.user.is_restaurant:
            res = Restaurant.objects.filter(owner_account__phone=request.user.phone).first()
            serializer = RestaurantSerializer(res, data=request.data, partial=True)
            image_file = request.FILES.get('image', None)
            if image_file is not None:
                if os.path.isfile(res.image.path):
                    os.remove(res.image.path)
                res.image = image_file
                res.save()
            logo_file = request.FILES.get('logo', None)
            if logo_file is not None:
                if os.path.isfile(res.logo.path):
                    os.remove(res.logo.path)
                res.logo = logo_file
                res.save()
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
        return Response(status=status.HTTP_403_FORBIDDEN)
