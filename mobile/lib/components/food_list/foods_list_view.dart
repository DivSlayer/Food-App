import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/food_list/food_list_item.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

class FoodsListView extends StatefulWidget {
  const FoodsListView({
    super.key,
    required this.foods,
    this.useDismissible = false,
    required this.onTap,
    this.reverse = false,
    this.onDismissed,
    required this.eliminated,
  });

  final List<FoodModel> foods;
  final bool useDismissible;
  final Function(FoodModel)? onDismissed;
  final Function(int) onTap;
  final bool reverse;
  final List<String> eliminated;

  @override
  State<FoodsListView> createState() => _FoodsListViewState();
}

class _FoodsListViewState extends State<FoodsListView> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.foods.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: dimmension(30, context)),
        child: GestureDetector(
          onTap: () => widget.onTap(index),
          child: widget.useDismissible
              ? Dismissible(
                  onDismissed: (direction) {
                    if (widget.onDismissed != null) {
                      widget.onDismissed!(widget.foods[index]);
                    }
                  },
                  direction: DismissDirection.startToEnd,
                  key: GlobalKey(),
                  background: _buildBackground(context),
                  child: FoodListItem(
                    food: widget.reverse
                        ? widget.foods.reversed.toList()[index]
                        : widget.foods[index],
                    eliminated: widget.eliminated.contains(widget.foods[index].uuid),
                  ),
                )
              : FoodListItem(
                  food:
                      widget.reverse ? widget.foods.reversed.toList()[index] : widget.foods[index],
                  eliminated: widget.eliminated.contains(widget.foods[index].uuid),
                ),
        ),
      ),
    );
  }

  Container _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimmension(20, context)),
        color: redColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline_rounded,
              size: dimmension(40, context),
              color: Colors.white,
            ),
          ),
          SizedBox(width: dimmension(5, context)),
          Text(
            'حذف',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
    );
  }
}
