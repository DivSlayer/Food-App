from django.contrib.auth import authenticate, login
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from Account.api_views import get_tokens_for_user
from Account.forms import AccountAuthentication, RegistrationForm
from Account.models import Account
from Account.serializers import AccountSerializer


class AccountDetailsAPI(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        user = Account.objects.get(phone=request.user.phone)
        serialized = AccountSerializer(user,context={'big': True})
        return Response(serialized.data)


class LoginAPIView(APIView):
    def post(self, request):
        form = AccountAuthentication(request.data)
        if form.is_valid():
            phone = form.cleaned_data['phone']
            password = form.cleaned_data["password"]
            user = authenticate(phone=phone, password=password)
            if user:
                login(request, user)
                return Response(get_tokens_for_user(user))
            return Response(
                {"error": "نام کاربری یا رمزعبور اشتباه است!"},
                status=status.HTTP_401_UNAUTHORIZED
            )
        else:
            print(form.errors)
            return Response(
                {'error': "خطایی رخ داده است!"},
                status=status.HTTP_400_BAD_REQUEST
            )


class RegisterAPIView(APIView):
    def post(self, request):
        account_form = RegistrationForm(request.data)
        if account_form.is_valid():
            instance = account_form.save()
            return Response(get_tokens_for_user(instance))
        else:
            print(account_form.errors)
            return Response({'error': 'Something went wrong!'.encode('utf-8')}, status=status.HTTP_400_BAD_REQUEST, )
