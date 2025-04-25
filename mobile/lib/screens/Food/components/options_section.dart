import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/components/number_counter.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/screens/Food/components/extras_option.dart';
import 'package:food_app/screens/Food/components/size_option.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class OptionsSection extends StatefulWidget {
  const OptionsSection({
    super.key,
    required this.onQuantityChange,
    required this.onExtrasChange,
    required this.onSizeChange,
    required this.food,
  });

  final Function(int) onQuantityChange;
  final Function(List<ExtraModel>) onExtrasChange;
  final Function(SizeModel) onSizeChange;
  final FoodModel food;

  @override
  State<OptionsSection> createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<OptionsSection> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NumberCounter(
                currentNumbers: quantity,
                onAdd: () {
                  setState(() {
                    quantity += 1;
                  });
                  widget.onQuantityChange(quantity);
                },
                onMinus: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity -= 1;
                    });
                    widget.onQuantityChange(quantity);
                  }
                }),
            Text(
              'تعداد',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        SizedBox(height: dimmension(15, context)),
        SizeOption(
          onSizeChange: (SizeModel size) => widget.onSizeChange(size),
          food: widget.food,
        ),
        SizedBox(height: dimmension(25, context)),
        ExtrasOption(
          onExtrasChange: (List<ExtraModel> extras) => widget.onExtrasChange(extras),
          food: widget.food,
        ),
      ],
    );
  }
}
