import 'package:flutter/material.dart';
import 'package:food_app/utils/dimension.dart';

import '../../theme/colors.dart';

class SquareIconButton extends StatelessWidget {
  const SquareIconButton(
      {super.key, required this.icon, required this.onTap, this.color, this.size, this.bgColor});

  final IconData icon;
  final Function() onTap;
  final Color? color;
  final Color? bgColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(dimmension(5, context)),
        margin: EdgeInsets.only(right: dimmension(30, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(5, context)),
          color: bgColor ?? yellowColor,
        ),
        child: Icon(
          icon,
          color: color ?? Colors.white,
          size: size ?? dimmension(25, context),
        ),
      ),
    );
  }
}
