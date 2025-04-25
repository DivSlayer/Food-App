from django import forms
from .models import OrderModel, TransactionModel, TransactionStatus, Status


class OrderForm(forms.ModelForm):
    class Meta:
        model = OrderModel
        fields = ['status',]  # Specify the fields you want in the form

    def __init__(self, *args, **kwargs):
        super(OrderForm, self).__init__(*args, **kwargs)
        # You can customize the form fields here, for example:
        self.fields['status'].widget = forms.Select(choices=Status.choices)


class TransactionForm(forms.ModelForm):
    class Meta:
        model = TransactionModel
        fields = ['total_duration', 'total_price', 'status']
        widgets = {
            'orders': forms.CheckboxSelectMultiple(),
            'total_price': forms.NumberInput(attrs={'step': '0.01'}),
        }

    def __init__(self, *args, **kwargs):
        super(TransactionForm, self).__init__(*args, **kwargs)
        # Customize labels and help texts if needed
        self.fields['status'].widget = forms.Select(choices=TransactionStatus.choices)
