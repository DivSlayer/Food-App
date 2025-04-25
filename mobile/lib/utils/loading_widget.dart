import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.loadColor, this.size});

  final Color? loadColor;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? dimmension(20, context),
            height: size ?? dimmension(20, context),
            child: CircularProgressIndicator(
              color: loadColor ?? blueColor,
              strokeCap: StrokeCap.round,
              strokeWidth: dimmension(4, context),
            ),
          ),
        ],
      ),
    );
  }
}
