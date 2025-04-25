import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/components/separator.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/models/transaction.dart';
import 'package:food_app/screens/Delivery/components/result_widget.dart';
import 'package:food_app/screens/Home/home_screen.dart';
import 'package:food_app/screens/Payment/components/transaction_item.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/services/transaction_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/funcs.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:food_app/utils/one_way_route.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic> arguments = Get.arguments;


  @override
  void initState() {
    super.initState();
    OrderService orderService = getOrderService();
    List<OrderModel> orders = arguments['orders'];
    TransactionService transactionService = getTransactionService();
    TransactionModel transactionModel = TransactionModel(
      serial: 1,
      orders: orders,
      paidTime: DateTime.now(),
      totalDuration: orders.fold(0, (prev, element) => prev + element.food.preparationTime),
      totalPrice: calculatePrice(orders),
      status: TransactionStatus.pending,
      deliveryCode: 1000,
      changedAt: DateTime.now(),
    );
    AddressModel? address = getAccountService().activeAddress;
    if (address != null) {
      transactionService.addTransaction(transaction: transactionModel, address: address);
      orderService.clearAllOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        margin: EdgeInsets.only(top: dimmension(10, context)),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResultWidget(),
            Expanded(
              child: Container(
                width: size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: dimmension(20, context),
                  vertical: dimmension(40, context),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: dimmension(20, context),
                  vertical: dimmension(20, context),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(dimmension(20, context)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "اطلاعات تراکنش",
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: dimmension(25, context)),
                          TransactionItem(title: 'شماره تراکنش', value: '1245985241'),
                          TransactionItem(title: 'تاریخ تراکنش', value: '18 اردیبهشت 10:30'),
                          TransactionItem(
                            title: 'هزینه پرداخت شده',
                            value: '${priceFormatter(1300000)} تومان',
                          ),
                          TransactionItem(
                            title: 'مالیات بر ارزش افزوده',
                            value: '${priceFormatter(200000)} تومان',
                          ),
                        ],
                      ),
                    ),
                    const Separator(),
                    TransactionItem(
                      title: 'هزینه نهایی',
                      value: "${priceFormatter(1500000)} نومان",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: dimmension(20, context)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bgColor,
      leading: IconButton(
        onPressed: () => Get.offAllNamed('home'),
        icon: Icon(Icons.chevron_left_rounded, size: dimmension(30, context)),
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    );
  }
}
