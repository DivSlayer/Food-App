import base64
import json

from django.contrib.auth import authenticate, login
from django.core.files.base import ContentFile
from django.shortcuts import render
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from Account.forms import RegistrationForm, AccountAuthentication
from Account.models import Account
from Account.serializers import AccountUpdateSerializer, AccountSerializer


class CreateAccountAPIView(APIView):
    def post(self, request):
        account_form = RegistrationForm(request.data)
        if account_form.is_valid():
            images_bytes = request.data.get('image_bytes', None)
            instance = account_form.save(commit=False)
            if images_bytes is not None and images_bytes != "":
                file = request.data.get('image_bytes')
                profile_image = ContentFile(base64.b64decode(file), 'profile.jpg')
                instance.profile_image = profile_image
            is_representative = int(request.data.get('role', 0)) == 1
            is_teacher = int(request.data.get('role', 0)) == 2
            is_verified = is_teacher or is_representative
            instance.is_representative = is_representative
            instance.is_teacher = is_teacher
            instance.is_verified = is_verified
            instance.save()
            return Response(get_tokens_for_user(instance))
        else:
            print(account_form.errors)
            # print(request.data)
            return Response({'error': 'Something went wrong!'.encode('utf-8')}, status=status.HTTP_400_BAD_REQUEST, )


def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }


class LoginAPIView(APIView):
    def post(self, request):
        form = AccountAuthentication(request.data)
        if form.is_valid():
            phone = form.cleaned_data['phone']
            password = form.cleaned_data["password"]
            instance = form.save(commit=False)
            if instance.is_restaurant:
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


class AccountDetailsAPIView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        serializer = AccountSerializer(request.user)
        return Response(serializer.data)

    def put(self, request):
        account = Account.objects.get(uuid=request.user.uuid)
        first_name = request.data.get('first_name', None)
        last_name = request.data.get('last_name', None)
        phone = request.data.get('phone', None)
        dict2 = {
            'first_name': first_name if first_name is not None else account.first_name,
            'last_name': last_name if last_name is not None else account.last_name,
            'phone': phone if phone is not None else account.phone,
        }
        form = AccountUpdateSerializer(account, data=dict2)
        if form.is_valid():
            form.save()
            images_bytes = request.data.get('image_bytes', None)
            if images_bytes is not None and images_bytes != "":
                file = request.data.get('image_bytes')
                profile_image = ContentFile(base64.b64decode(file), 'profile.jpg')
                account.profile_image = profile_image
            account.save()
            return Response(AccountSerializer(account).data)
        else:
            print(form.errors)
            return Response({'error': 'خطایی رخ داده است!'}, status=status.HTTP_400_BAD_REQUEST)

