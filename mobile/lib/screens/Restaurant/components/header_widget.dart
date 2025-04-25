import 'package:flutter/material.dart';
import 'package:food_app/components/circle_button.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: dimmension(350, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(dimmension(20, context)),
              bottomRight: Radius.circular(dimmension(20, context)),
            ),
            image: DecorationImage(image: NetworkImage(restaurant.image), fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: CircleButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        SizedBox(height: dimmension(20, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(restaurant.name, style: Theme.of(context).textTheme.displayLarge),
              SizedBox(width: dimmension(15, context)),
              Container(
                height: dimmension(40, context),
                width: dimmension(40, context),
                padding: EdgeInsets.all(dimmension(5, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(5, context)),
                  color: lightBgColor,
                  boxShadow: [
                    BoxShadow(
                      color: borderColor.withOpacity(0.5),
                      offset: const Offset(3, 12),
                      blurRadius: dimmension(5, context),
                    ),
                  ],
                ),
                child: Image.network(restaurant.logo),
              ),
            ],
          ),
        ),
        SizedBox(height: dimmension(30, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, size: dimmension(20, context), color: yellowColor),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: textColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: "  (${restaurant.commentsCount})",
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontFamily: 'Poppins',
                            fontSize: dimmension(12, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'از ساعت 11:00 تا 18:00 باز است',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
        SizedBox(height: dimmension(15, context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('comment', arguments: {"comment_for": restaurant.uuid}),
                child: Row(
                  children: [
                    Icon(Icons.chevron_left, size: dimmension(20, context), color: textColor),
                    Text(
                      'دیدن نظرات',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
              Text(
                restaurant.cats?.keys.join(', ') ?? "",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
