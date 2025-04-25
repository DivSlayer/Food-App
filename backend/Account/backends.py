# your_app/backends.py  
from django.contrib.auth.backends import ModelBackend  
from django.contrib.auth import get_user_model  
from django.core.exceptions import ValidationError  

User = get_user_model()  

class PhoneNumberFormatInsensitive(ModelBackend):  
    def authenticate(self, request, username=None, password=None, **kwargs):  
        if username is None:  
            username = kwargs.get(User.USERNAME_FIELD)  

        # Normalize the phone number format  
        try:  
            normalized_username = self.normalize_phone_number(username)  
        except ValidationError:  
            return None  # Return None, which indicates an authentication failure  

        try:  
            user = User.objects.get(**{User.USERNAME_FIELD: normalized_username})  
        except User.DoesNotExist:  
            return None  
        
        # Check the password  
        if user.check_password(password):  
            return user  
        
        return None  

    def normalize_phone_number(self, phone_number):  
        # Remove non-numeric characters  
        normalized = ''.join(filter(str.isdigit, phone_number))  

        # Check if the phone number is valid  
        if normalized.startswith('09'):  
            return normalized  # Already in the correct format  
        elif normalized.startswith('9') and len(normalized) == 10:  
            return '0' + normalized  # Convert '9XXXXXXXXX' to '09XXXXXXXXX'  
        else:  
            # Raise an error for invalid phone number formats  
            raise ValidationError("Invalid phone number. It must start with '09' or '9'.")