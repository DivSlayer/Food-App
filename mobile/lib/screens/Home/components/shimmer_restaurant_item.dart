import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRestaurantItem extends StatelessWidget {
  const ShimmerRestaurantItem({super.key, required this.current, required this.index});

  final double current;
  final int index;

  @override
  Widget build(BuildContext context) {
    double opacity = 0.5;
    if (index.toDouble() < current) {
      opacity = 1 - ((current - index) / 2);
    } else if (index.toDouble() == current) {
      opacity = 1;
    } else if (index.toDouble() > current) {
      opacity = 1 - ((index - current) / 2);
    }
    double scale = 1;
    if (index.toDouble() < current) {
      scale = 1 - ((current - index) / 12);
    } else if (index.toDouble() == current) {
      scale = 1;
    } else if (index.toDouble() > current) {
      scale = 1 - ((index - current) / 12);
    }
    return AnimatedScale(
      duration: const Duration(microseconds: 300),
      scale: scale,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 0),
        opacity: opacity.toDouble(),
        child: Container(
          width: (MediaQuery.of(context).size.width - dimmension(40, context)) / 2,
          height: dimmension(300, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimmension(15, context)),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                  color: borderColor.withOpacity(0.5),
                  offset: const Offset(7, 7),
                  blurRadius: dimmension(5, context))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              SizedBox(height: dimmension(50, context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dimmension(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: yellowColor.withOpacity(0.3),
                          highlightColor: yellowColor.withOpacity(0.1),
                          child: Container(
                            width: dimmension(70, context),
                            height: dimmension(25, context),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(dimmension(5, context)),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: dimmension(150, context),
                                height: dimmension(35, context),
                                decoration: BoxDecoration(
                                  color: lightBgColor,
                                  borderRadius: BorderRadius.circular(dimmension(5, context)),
                                ),
                              ),
                            ),
                            SizedBox(height: dimmension(15, context)),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: dimmension(200, context),
                                height: dimmension(25, context),
                                decoration: BoxDecoration(
                                  color: lightBgColor,
                                  borderRadius: BorderRadius.circular(dimmension(5, context)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: dimmension(20, context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: dimmension(70, context),
                            height: dimmension(25, context),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(dimmension(5, context)),
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: dimmension(70, context),
                            height: dimmension(25, context),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(dimmension(5, context)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildHeader(BuildContext context) {
    return SizedBox(
      height: dimmension(170, context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: dimmension(170, context),
              padding: EdgeInsets.all(dimmension(10, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(dimmension(10, context)),
                  topRight: Radius.circular(dimmension(10, context)),
                ),
                color: lightBgColor,
              ),
            ),
          ),
          Positioned(
            bottom: dimmension(-30, context),
            right: dimmension(20, context),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: dimmension(60, context),
                width: dimmension(60, context),
                padding: EdgeInsets.all(dimmension(10, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(5, context)),
                  color: lightBgColor,
                  boxShadow: [
                    BoxShadow(
                        color: borderColor.withOpacity(0.5),
                        offset: const Offset(3, 12),
                        blurRadius: dimmension(5, context))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
