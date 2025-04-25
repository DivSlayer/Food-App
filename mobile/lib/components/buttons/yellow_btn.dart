import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/loading_widget.dart';

class YellowBtn extends StatelessWidget {
  const YellowBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.textC,
    this.bgColor,
    this.radius,
    this.padding,
    this.isSending = false,
    this.loadColor,
  });

  final String title;
  final Color? textC, bgColor;
  final double? radius;
  final Function onTap;
  final EdgeInsets? padding;
  final bool isSending;
  final Color? loadColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: dimmension(13, context),
              horizontal: dimmension(20, context),
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? dimmension(15, context)),
          color: bgColor ?? yellowColor,
        ),
        child: Center(
          child: isSending
              ? LoadingWidget(
                  loadColor: loadColor ?? Colors.white,
                )
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: dimmension(18, context),
                        color: textC ?? textColor,
                      ),
                ),
        ),
      ),
    );
  }
}
