

import 'package:flutter/material.dart';
import 'package:food_app/utils/dimension.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key, required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: dimmension(20, context),
          top: dimmension(40, context),
        ),
        width: dimmension(35, context),
        height: dimmension(35, context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Icon(
          Icons.chevron_left_rounded,
          size: dimmension(30, context),
          color: Colors.white,
        ),
      ),
    );
  }
}
