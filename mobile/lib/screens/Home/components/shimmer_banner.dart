import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: EdgeInsets.all(dimmension(20, context)),
            height: dimmension(100, context),
            margin: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimmension(10, context)),
              color: lightBgColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.only(left: dimmension(40, context)),
              height: dimmension(120, context),
              width: dimmension(120, context),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: lightBgColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
