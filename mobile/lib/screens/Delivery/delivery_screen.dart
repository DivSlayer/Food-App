import 'package:flutter/material.dart';
import 'package:food_app/components/count_down_timer.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/transaction.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/services/transaction_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/funcs.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:intl/intl.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefresh() async {
    TransactionService transactionService = getTransactionService();
    transactionService.getTransactions();
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  String getTransactionStatus(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'در انتظار تایید';
      case TransactionStatus.accepted:
        return 'تایید شده';
      case TransactionStatus.declined:
        return 'رد شده';
      case TransactionStatus.completed:
        return 'تکمیل شده';
      case TransactionStatus.canceled:
        return 'کنسل شده';
    }
  }

  @override
  Widget build(BuildContext context) {
    TransactionService transactionService = TransactionService();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: CheckMarkIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: dimmension(10, context),
                      left: dimmension(10, context),
                      right: dimmension(20, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.chevron_left_rounded, size: dimmension(30, context)),
                        ),
                        Text(
                          'لیست سفارش ها',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge!.copyWith(color: yellowColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: dimmension(20, context)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactionService.transactionsList.length,
                      padding: EdgeInsets.only(bottom: dimmension(10, context)),
                      itemBuilder: (context, index) {
                        TransactionModel item = transactionService.transactionsList[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: dimmension(20, context),
                            vertical: dimmension(30, context),
                          ),
                          child: Dismissible(
                            onDismissed: (direction) {
                              transactionService.removeTransaction(item.serial);
                            },
                            direction:
                                item.status != TransactionStatus.pending
                                    ? DismissDirection.startToEnd
                                    : DismissDirection.none,
                            background: _buildBackground(context),
                            key: UniqueKey(),
                            child: Container(
                              padding: EdgeInsets.all(dimmension(15, context)),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(dimmension(10, context)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(5, 5),
                                    color: borderColor.withOpacity(0.5),
                                    blurRadius: dimmension(10, context),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'شماره سفارش: ${item.serial}',
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                            color: textColor,
                                            fontSize: dimmension(14, context),
                                          ),
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                        Text(
                                          'زمان پرداخت: ${DateFormat('HH:mm').format(item.paidTime.toLocal())}',
                                          style: Theme.of(context).textTheme.displaySmall!,
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                        Text(
                                          'مبلغ سفارش: ${priceFormatter(item.totalPrice)} تومان',
                                          style: Theme.of(context).textTheme.displaySmall!,
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                        Text(
                                          'زمان تقریبی تحویل: ${DateFormat('HH:mm').format(item.paidTime.toLocal().add(Duration(minutes: item.totalDuration)))}',
                                          style: Theme.of(context).textTheme.displaySmall!,
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                        Text(
                                          'کد تحویل: ${item.deliveryCode}',
                                          style: Theme.of(context).textTheme.displaySmall!,
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                        Text(
                                          'وضعیت: ${getTransactionStatus(item.status)}',
                                          style: Theme.of(context).textTheme.displaySmall!,
                                        ),
                                        SizedBox(height: dimmension(15, context)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: dimmension(20, context)),
                                  item.status == TransactionStatus.accepted
                                      ? CountdownTimer(
                                        startTime: item.changedAt,
                                        totalTime: item.totalDuration,
                                      )
                                      : SizedBox(
                                        width: dimmension(50, context),
                                        height: dimmension(50, context),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimmension(20, context)),
        color: redColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline_rounded,
              size: dimmension(40, context),
              color: Colors.white,
            ),
          ),
          SizedBox(width: dimmension(5, context)),
          Text(
            'حذف',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
