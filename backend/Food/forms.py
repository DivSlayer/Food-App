from django.forms import ModelForm

from Food.models import Food


class FoodForm(ModelForm):
    class Meta:
        model = Food
        fields = [
            'name',
            'details',
            'image',
            'preparation_time',
            'rating',
            'stack',
            'category',
        ]  # Specify the fields you want in the form
