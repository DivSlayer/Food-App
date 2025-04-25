import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';

class FoodSearchItem extends StatelessWidget {
  const FoodSearchItem({super.key, required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  food.name,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: dimmension(18, context),
                      ),
                ),
                SizedBox(height: dimmension(10, context)),
                SizedBox(
                  width: dimmension(200, context),
                  child: Text(
                    food.details,
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
                Container(
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
                SizedBox(
                  width: dimmension(240, context),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${priceFormatter(food.sizes[0].price)} تومان',
                        textDirection: TextDirection.rtl,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(color: yellowColor),
                      )
                    ],
                  ),
                ),
                SizedBox(height: dimmension(10, context)),
              ],
            ),
          ),
          SizedBox(width: dimmension(15, context)),
          Container(
            width: dimmension(100, context),
            height: dimmension(100, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimmension(11.25, context)),
              color: lightBgColor,
            ),
            padding: EdgeInsets.all(dimmension(5, context)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dimmension(10, context)),
              child: Image.network(
                food.image,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
