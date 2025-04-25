import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class SizeOption extends StatefulWidget {
  const SizeOption({super.key, required this.onSizeChange, required this.food});

  final Function(SizeModel) onSizeChange;
  final FoodModel food;

  @override
  State<SizeOption> createState() => _SizeOptionState();
}

class _SizeOptionState extends State<SizeOption> {
  SizeModel? selectedSize;

  // List<SizeModel> sizes = [
  //   SizeModel(name: 'تک نفره', details: '20 * 20 سانتی متر', price: 150000),
  //   SizeModel(name: 'متوسط', details: '25 * 25 سانتی متر', price: 300000),
  //   SizeModel(name: 'خانواده', details: '30 * 30 سانتی متر', price: 450000),
  // ];

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.food.sizes.length > 2) {
        selectedSize = widget.food.sizes[1];
      } else {
        selectedSize = widget.food.sizes.isNotEmpty ? widget.food.sizes[0] : null;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedSize != null) {
        widget.onSizeChange(selectedSize!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                widget.food.sizes.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = widget.food.sizes[index];
                    });
                    widget.onSizeChange(widget.food.sizes[index]);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : dimmension(15, context),
                    ),
                    padding: EdgeInsets.all(dimmension(7, context)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(dimmension(20, context)),
                      border: Border.all(
                        width: 1,
                        color: selectedSize == widget.food.sizes[index]
                            ? yellowColor
                            : borderColor.withOpacity(0.5),
                      ),
                      color: selectedSize == widget.food.sizes[index] ? yellowColor : bgColor,
                    ),
                    child: Text(
                      widget.food.sizes[index].name,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: selectedSize == widget.food.sizes[index]
                                ? Colors.white
                                : lightTextColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'اندازه',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        SizedBox(height: dimmension(10, context)),
        selectedSize != null
            ? Text(
                'راهنما: ${selectedSize!.details} سانتی متر',
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.displaySmall,
              )
            : Container(),
      ],
    );
  }
}
