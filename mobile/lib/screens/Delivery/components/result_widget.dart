import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: dimmension(240, context),
          height: dimmension(240, context),
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(dimmension(40, context)),
                  width: dimmension(230, context),
                  height: dimmension(230, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: greenColor.withOpacity(0.2),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenColor.withOpacity(0.6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: dimmension(80, context),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset(
                  'assets/vectors/star-1.svg',
                  height: dimmension(40, context),
                  color: purpleColor,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'assets/vectors/star-2.svg',
                  height: dimmension(30, context),
                  color: yellowColor,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(
                    right: dimmension(20, context),
                    top: dimmension(50, context),
                  ),
                  child: SvgPicture.asset(
                    'assets/vectors/star-2.svg',
                    height: dimmension(30, context),
                    color: purpleColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                    right: dimmension(5, context),
                    bottom: dimmension(50, context),
                  ),
                  child: SvgPicture.asset(
                    'assets/vectors/star-1.svg',
                    height: dimmension(30, context),
                    color: yellowColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: dimmension(30, context)),
        Text(
          'با موفقیت پرداخت شد!',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: dimmension(18, context),
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: dimmension(15, context)),
        Text(
          'سفارش شما در صف انتظار قرار گرفته است',
          style: Theme.of(context).textTheme.displaySmall,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
