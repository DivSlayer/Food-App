import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/components/number_counter.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';

class ExtrasOption extends StatefulWidget {
  const ExtrasOption({super.key, required this.onExtrasChange, required this.food});

  final FoodModel food;
  final Function(List<ExtraModel>) onExtrasChange;

  @override
  State<ExtrasOption> createState() => _ExtrasOptionState();
}

class _ExtrasOptionState extends State<ExtrasOption> {
  Map<ExtraModel, int> extrasQuantity = {};
  List<ExtraModel> selectedExtras = [];

  @override
  void initState() {
    super.initState();
    for(var extra in widget.food.restaurant!.extras){
      setState(() {
        extrasQuantity[extra] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'اضافیجات',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(height: dimmension(20, context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            widget.food.restaurant!.extras.length,
            (index) => Container(
              margin: EdgeInsets.only(top: index != 0 ? dimmension(20, context) : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberCounter(
                    currentNumbers: extrasQuantity[widget.food.restaurant!.extras[index]] ?? 0,
                    onAdd: () {
                      setState(() {
                        extrasQuantity[widget.food.restaurant!.extras[index]] = (extrasQuantity[widget.food.restaurant!.extras[index]] ?? 0) + 1;
                        selectedExtras.add(widget.food.restaurant!.extras[index]);
                      });
                      widget.onExtrasChange(selectedExtras);
                    },
                    onMinus: () {
                      setState(() {
                        extrasQuantity[widget.food.restaurant!.extras[index]] = (extrasQuantity[widget.food.restaurant!.extras[index]] ?? 1) - 1;
                        selectedExtras.remove(widget.food.restaurant!.extras[index]);
                      });
                      widget.onExtrasChange(selectedExtras);
                    },
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.food.restaurant!.extras[index].name,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: textColor,
                                ),
                          ),
                          SizedBox(height: dimmension(15, context)),
                          Text(
                            "${priceFormatter(widget.food.restaurant!.extras[index].price)} تومان ",
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: yellowColor,
                                  fontSize: dimmension(12, context),
                                ),
                          )
                        ],
                      ),
                      SizedBox(width: dimmension(10, context)),
                      SvgPicture.network(
                        widget.food.restaurant!.extras[index].icon,
                        width: dimmension(30, context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
