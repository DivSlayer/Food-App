import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton(
      {super.key,
      this.iconSize,
      this.iconColor,
      this.bgColor,
      required this.onTap,
      required this.icon});

  final double? iconSize;
  final Color? iconColor, bgColor;
  final Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(dimmension(2, context)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? textColor.withOpacity(0.3),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: iconSize ?? dimmension(30, context),
        ),
      ),
    );
  }
}
