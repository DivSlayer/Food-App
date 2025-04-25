import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFoodListItem extends StatelessWidget {
  const ShimmerFoodListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(dimmension(10, context)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(15, context)),
          border: Border.all(
            color: borderColor.withOpacity(0.5),
            width: 1,
          )),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: dimmension(100, context),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimmension(10, context)),
            color: lightBgColor,
          ),
        ),
      ),
    );
  }
}
