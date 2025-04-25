import 'package:flutter/material.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:get/get.dart';

class RestaurantSearchItem extends StatelessWidget {
  const RestaurantSearchItem({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('restaurant', arguments: {'uuid': restaurant.uuid});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: dimmension(25, context)),
        padding: EdgeInsets.all(dimmension(10, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(15, context)),
          color: bgColor,
          border: Border.all(
            color: borderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "رستوران ${restaurant.name}",
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: dimmension(18, context),
                        ),
                  ),
                  SizedBox(height: dimmension(10, context)),
                  SizedBox(
                    width: dimmension(200, context),
                    child: Text(
                      'واقع در ${restaurant.addresses[0].briefAddress}',
                      softWrap: true,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: dimmension(12, context),
                            height: 1.5,
                          ),
                    ),
                  ),
                  SizedBox(height: dimmension(15, context)),
                ],
              ),
            ),
            SizedBox(width: dimmension(15, context)),
            Container(
              width: dimmension(100, context),
              height: dimmension(100, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimmension(10, context)),
                color: lightBgColor,
              ),
              padding: EdgeInsets.all(dimmension(5, context)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(dimmension(10, context)),
                child: Image.network(
                  restaurant.logo,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
