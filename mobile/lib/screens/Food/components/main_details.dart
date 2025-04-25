import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart' show FoodModel;
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:get/get.dart';

class MainDetails extends StatelessWidget {
  const MainDetails({
    super.key,
    required this.price,
    required this.food,
  });

  final int price;
  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed('restaurant', arguments: {'uuid': food.restaurant!.uuid}),
          child: Container(
            margin: EdgeInsets.only(bottom: dimmension(15, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  food.restaurant!.name,
                  softWrap: true,
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: dimmension(12, context),
                        height: 1.5,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                SizedBox(width: dimmension(10, context)),
                Container(
                  width: dimmension(30, context),
                  height: dimmension(30, context),
                  padding: EdgeInsets.all(dimmension(5, context)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dimmension(5, context)),
                    color: lightBgColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(dimmension(5, context)),
                    child: Image.network(food.restaurant!.logo),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: dimmension(15, context)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${priceFormatter(price)} تومان',
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: yellowColor,
                  ),
            ),
            Text(
              food.name,
              style: Theme.of(context).textTheme.displayLarge,
            )
          ],
        ),
        SizedBox(height: dimmension(20, context)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${food.preparationTime} دقیقه',
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(width: dimmension(3, context)),
                Icon(
                  Icons.access_time_outlined,
                  color: yellowColor,
                  size: dimmension(20, context),
                ),
              ],
            ),
            food.commentsCount > 0
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: yellowColor,
                        size: dimmension(20, context),
                      ),
                      SizedBox(width: dimmension(3, context)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: food.rating.toString(),
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    color: textColor,
                                    fontFamily: 'Poppins',
                                  ),
                            ),
                            TextSpan(
                              text: "  (${food.commentsCount})",
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontFamily: 'Poppins',
                                    fontSize: dimmension(12, context),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
        GestureDetector(
                onTap: () => Get.toNamed('comment', arguments: {'comment_for': food.uuid}),
                child: Container(
                  margin: EdgeInsets.only(top: dimmension(20, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: dimmension(20, context),
                        color: textColor,
                      ),
                      Text(
                        'دیدن نظرات',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: textColor),
                      ),
                    ],
                  ),
                ),
              )
            ,
      ],
    );
  }
}
