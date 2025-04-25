from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models

from Account.models import Account
from Address.models import Address
from Extras.models import Extra
from Food.models import Food, SizeModel
from Instruction.models import Instruction
from Restaurant.models import Restaurant
from Utils.functions import get_uuid, get_random_num
from Utils.views import generate_random_number


class TransactionStatus(models.TextChoices):
    PENDING = 'PE', 'Pending'
    COMPLETED = 'CO', 'Completed'
    COMPLETING = 'CI', 'Completing'
    CANCELED = 'CA', 'Canceled'
    ACCEPTED = 'AC', 'Accepted'
    DECLINED = 'DE', 'Declined'


class Status(models.TextChoices):
    PENDING = 'PE', 'Pending'
    COMPLETED = 'CA', 'Cancelled'
    PAID = 'PA', 'Paid'


class TransactionModel(models.Model):
    serial = models.IntegerField(primary_key=True, unique=True, editable=False,
                                 default=generate_random_number)  # Auto-incrementing primary key
    paid_time = models.DateTimeField(auto_now_add=False, auto_now=False)  # DateTimeField for paid time
    total_duration = models.IntegerField()  # Total duration in seconds or minutes
    total_price = models.IntegerField()  # Total price
    status = models.CharField(max_length=2, choices=TransactionStatus.choices)  # Transaction status
    created_by = models.ForeignKey(Account, on_delete=models.CASCADE)
    delivery_code = models.PositiveIntegerField(validators=[
        MaxValueValidator(9999),
        MinValueValidator(1000)
    ], default=get_random_num)
    address = models.ForeignKey(Address, on_delete=models.CASCADE,null=True,blank=True)
    changed_at = models.DateTimeField(auto_now_add=False, auto_now=False)


    def __str__(self):
        return f'Transaction {self.serial} - {self.status}'

    class Meta:
        verbose_name = "Transaction"
        verbose_name_plural = "Transactions"


class OrderModel(models.Model):
    uuid = models.CharField(unique=True, primary_key=True, max_length=15, default=get_uuid, editable=False)
    transaction = models.ForeignKey(TransactionModel, on_delete=models.CASCADE,null=True)
    food = models.ForeignKey(Food, on_delete=models.CASCADE, related_name='orders')
    food_size = models.ForeignKey(SizeModel, on_delete=models.DO_NOTHING, related_name='orders', null=True)
    quantity = models.PositiveIntegerField(default=1)
    extra_options = models.ManyToManyField(Extra, through='OrderItemExtraOption')
    instructions = models.ManyToManyField(Instruction, through='OrderItemInstructionOption')
    status = models.CharField(max_length=2, choices=Status.choices)
    created_by = models.ForeignKey(Account, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE, null=True)
    created_time = models.DateTimeField(
        auto_now_add=True, auto_now=False)  # Automatically set the field to now when the object is created

    def __str__(self):
        return f'Order of {self.food.name} - Status: {self.status} - {self.uuid}'

    class Meta:
        verbose_name = "Order"
        verbose_name_plural = "orders"


class OrderItemExtraOption(models.Model):
    order_item = models.ForeignKey(OrderModel, on_delete=models.CASCADE)
    extra_option = models.ForeignKey(Extra, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.quantity} x {self.extra_option.name} for {self.order_item.uuid}"


class OrderItemInstructionOption(models.Model):
    order_item = models.ForeignKey(OrderModel, on_delete=models.CASCADE)
    instruction_option = models.ForeignKey(Instruction, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.quantity} x {self.instruction_option.name} for {self.order_item.uuid}"
