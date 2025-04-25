import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

class FoodSwitcherList extends StatefulWidget {
  const FoodSwitcherList({super.key, required this.foods});

  final List<FoodModel> foods;

  @override
  State<FoodSwitcherList> createState() => _FoodSwitcherListState();
}

class _FoodSwitcherListState extends State<FoodSwitcherList> {
  Map<int, int> numbers = {};

  @override
  void initState() {
    super.initState();
    int current = 0;
    for (var item in widget.foods) {
      setState(() {
        numbers[current] = 0;
      });
      current += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          widget.foods.length,
          (index) {
            FoodModel food = widget.foods[index];
            return GestureDetector(
              onTap: () => Get.toNamed(
                'food',
                arguments: {"food": food},
              ),
              child: Container(
                padding: EdgeInsets.all(dimmension(10, context)),
                margin: EdgeInsets.only(bottom: dimmension(25, context)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dimmension(15, context)),
                    border: Border.all(
                      color: borderColor.withOpacity(0.5),
                      width: 1,
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
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
                        SizedBox(
                          width: dimmension(240, context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  numbers[index] != 0
                                      ? IconButton(
                                          icon: Icon(
                                            CupertinoIcons.minus_circle,
                                            color: lightTextColor,
                                            size: dimmension(25, context),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              numbers[index] = (numbers[index]! - 1);
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                        )
                                      : Container(),
                                  numbers[index] != 0
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            left: numbers[index] == 0 ? 0 : dimmension(0, context),
                                          ),
                                          child: Text(
                                            "${numbers[index]}",
                                            textAlign: TextAlign.center,
                                            style:
                                                Theme.of(context).textTheme.displayMedium!.copyWith(
                                                      fontFamily: 'Poppins',
                                                    ),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: numbers[index] == 0 ? 0 : dimmension(0, context),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_circle_rounded,
                                        color: yellowColor,
                                        size: dimmension(25, context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          numbers[index] = (numbers[index]! + 1);
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '190،000 تومان',
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: yellowColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: dimmension(10, context)),
                    Container(
                      width: dimmension(100, context),
                      height: dimmension(100, context),
                      padding: EdgeInsets.all(dimmension(7, context)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dimmension(11.25, context)),
                        color: lightBgColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(dimmension(11.25, context)),
                        child: Image.network(food.image),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
