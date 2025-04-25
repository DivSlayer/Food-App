from django.contrib import admin

from Transaction.models import TransactionModel, OrderModel, OrderItemInstructionOption, OrderItemExtraOption

admin.site.register(TransactionModel)
admin.site.register(OrderModel)
admin.site.register(OrderItemInstructionOption)
admin.site.register(OrderItemExtraOption)
