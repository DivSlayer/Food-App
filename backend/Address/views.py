from django.shortcuts import render
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from Account.models import Account
from Address.models import Address
from Address.serializers import AddressSerializer
from Restaurant.models import Restaurant


class AddressListAPIView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        if request.user.is_restaurant:
            user = Account.objects.get(phone=request.user.phone)
            addresses = Address.objects.filter(owner_account=user)
            serializer = AddressSerializer(addresses, many=True)
            return Response({'addresses': serializer.data})
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def post(self, request):
        data = request.data.copy()  # Copy to avoid modifying the original request.data
        uuid = data.get('uuid')
        if type(uuid) is str:
            try:
                user = Account.objects.get(phone=request.user.phone)
                address = Address.objects.get(uuid=uuid, owner_account=user)
                serializer = AddressSerializer(data=data, instance=address)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data)
                else:
                    return Response(status=status.HTTP_400_BAD_REQUEST)
            except Address.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            account = Account.objects.get(phone=request.user.phone)
            serializer = AddressSerializer(data=data)
            if serializer.is_valid():
                address = Address(**serializer.validated_data, owner_account=account)
                address.save()
                return Response(serializer.data)
            else:
                print(serializer.errors)
            return Response(status=status.HTTP_400_BAD_REQUEST)


class SingleAPIView(APIView):
    def get(self, request, uuid):
        try:
            user = Account.objects.get(phone=request.user.phone)
            address = Address.objects.get(uuid=uuid)
            if user == address.owner_account:
                serializer = AddressSerializer(address)
                return Response({'addresses': [serializer.data]})
            else:
                return Response(status=status.HTTP_401_UNAUTHORIZED)
        except Address.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def delete(self, request, uuid):
        try:
            user = Account.objects.get(phone=request.user.phone)
            address = Address.objects.get(uuid=uuid)
            if user == address.owner_account:
                address.delete()
                return Response({'result': 'Done!'})
            else:
                return Response(status=status.HTTP_401_UNAUTHORIZED)
        except Address.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def put(self, request, uuid):
        try:
            user = Account.objects.get(phone=request.user.phone)
            address = Address.objects.get(uuid=uuid)
            if user == address.owner_account:
                serializer = AddressSerializer(data=request.data, instance=address, partial=True)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data)
                return Response({'error': 'Failed!'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(status=status.HTTP_401_UNAUTHORIZED)
        except Address.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
