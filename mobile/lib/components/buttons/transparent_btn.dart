import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class TransparentBtn extends StatelessWidget {
  const TransparentBtn({super.key, required this.title, required this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: dimmension(10, context),
          horizontal: dimmension(20, context),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimmension(15, context)),
            color: bgColor,
            border: Border.all(
              color: borderColor.withOpacity(0.5),
              width: 1,
            )),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
