import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

void showSnack(String msg, BuildContext context, {Color color = greenColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: const Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: dimmension(15, context),
            ),
          ),
          Text(
            msg,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    ),
  );
}
