import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.name, required this.image, required this.totalPrice, required this.eachPrice, required this.quantity});

  final String name;
  final Widget image;
  final int totalPrice;
  final int eachPrice;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: dimmension(30, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${priceFormatter(eachPrice)} تومان',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: yellowColor,
                          ),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: dimmension(20, context)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${priceFormatter(totalPrice)} تومان',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: yellowColor,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$quantity',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontFamily: 'Poppins',
                                color: yellowColor,
                              ),
                        ),
                        Icon(
                          Icons.close,
                          color: yellowColor,
                          size: dimmension(15, context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: dimmension(20, context)),
          Container(
            padding: EdgeInsets.all(dimmension(5, context)),
            width: dimmension(70, context),
            height: dimmension(70, context),
            decoration: BoxDecoration(
              color: lightBgColor,
              borderRadius: BorderRadius.circular(dimmension(10, context)),
            ),
            child: image,
          ),
        ],
      ),
    );
  }
}
