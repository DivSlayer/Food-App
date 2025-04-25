import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class Separator extends StatelessWidget {
  const Separator({
    super.key, this.marginSize,
  });
  final double? marginSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: marginSize ?? dimmension(30, context),
      ),
      height: dimmension(1, context),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(dimmension(20, context)),
      ),
    );
  }
}
