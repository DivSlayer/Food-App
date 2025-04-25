import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategoriesList extends StatelessWidget {
  const ShimmerCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      reverse: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(
          left: dimmension(20, context),
          right: index == 0 ? dimmension(20, context) : 0,
        ),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: dimmension(70, context),
                height: dimmension(70, context),
                padding: EdgeInsets.all(dimmension(10, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(10, context)),
                  color: lightBgColor,
                  border: Border.all(
                    color: yellowColor,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            SizedBox(height: dimmension(10, context)),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: dimmension(70, context),
                height: dimmension(15, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(5, context)),
                  color: lightBgColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
