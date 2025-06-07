from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView

from Banner.models import Banner
from Banner.serializers import BannerSerializer


class BannerAPIListView(APIView):
    def get(self, request):
        banners = Banner.objects.all()
        if len(banners) > 0:
            return Response({'banners': [BannerSerializer(banners.first()).data]})
        else:
            return Response({'banners': []})
