import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/food_list/shimmer_food_list_item.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

import 'food_list_item.dart';

class ShimmerFoodsList extends StatefulWidget {
  const ShimmerFoodsList({
    super.key,
    this.reverse = false, required this.length,
  });

  final int length;
  final bool reverse;

  @override
  State<ShimmerFoodsList> createState() => _ShimmerFoodsListState();
}

class _ShimmerFoodsListState extends State<ShimmerFoodsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: dimmension(30, context)),
        child: const ShimmerFoodListItem(),
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
