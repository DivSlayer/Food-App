from django import forms
from django.contrib.auth import authenticate
from django.contrib.auth.forms import UserCreationForm

from Account.models import Account


class RegistrationForm(UserCreationForm):
    phone = forms.CharField(
        max_length=254, help_text="Required. Add a valid phone number"
    )

    first_name = forms.CharField(
        max_length=100, help_text="Required. Add a valid first name"
    )
    last_name = forms.CharField(
        max_length=100, help_text="Required. Add a valid last name"
    )

    class Meta:
        model = Account
        fields = ("phone", "first_name", 'last_name', "password1", "password2")

    def clean_phone(self):
        phone = self.cleaned_data["phone"].lower()
        try:
            phone = int(phone)
            if str(phone)[0] != "0":
                phone = "".join(str(phone)[0:])
                phone = f"0{phone}"
            if str(phone)[0:3] == "+98":
                phone = "0".join(phone[3:])
            account = Account.objects.get(phone=phone)
        except Account.DoesNotExist as e:
            return phone
        raise forms.ValidationError(f"phone number {phone} is already taken!")


class AccountAuthentication(forms.ModelForm):
    password = forms.CharField(label="Password", widget=forms.PasswordInput)

    class Meta:
        model = Account
        fields = ("phone", "password")

    def clean(self):
        if self.is_valid():
            phone = self.cleaned_data['phone']
            password = self.cleaned_data['password']
            try:
                authenticate(phone=phone, password=password)
            except Exception as e:
                print(e)
                raise forms.ValidationError("Invalid Login")


class UpdateAccountForm(forms.ModelForm):
    class Meta:
        model = Account
        fields = ("phone", "first_name", 'last_name')
