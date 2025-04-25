import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/separator.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/models/instruction.dart';
import 'package:food_app/screens/Food/components/main_details.dart';
import 'package:food_app/screens/Food/components/options_section.dart';
import 'package:food_app/services/favorite_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:provider/provider.dart';

class DetailsContainer extends StatefulWidget {
  const DetailsContainer({
    super.key,
    required this.instructions,
    required this.food,
    required this.onDetailsUpdate,
  });

  final List<InstructionModel> instructions;
  final FoodModel food;
  final void Function(List<ExtraModel>?, SizeModel?, int?) onDetailsUpdate;

  @override
  State<DetailsContainer> createState() => _DetailsContainerState();
}

class _DetailsContainerState extends State<DetailsContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FavoriteService favoriteService = FavoriteService();
  SizeModel? selectedSize;
  List<ExtraModel> extras = [];
  int quantity = 1;
  bool isFavorite = false;

  String calculateTotalPriceString() {
    var (stringed, num) = calculateTotalPrice();
    return stringed;
  }

  (String, int) calculateTotalPrice() {
    int extrasFee = extras
        .map((extra) => extra.price)
        .toList()
        .fold(0, (previous, current) => previous + current);
    int instructionsFee = widget.instructions
        .map((instruction) => instruction.price)
        .toList()
        .fold(0, (previous, current) => previous + current);
    int quantityFee = quantity * (selectedSize?.price ?? 0);
    int totalNum = quantityFee + extrasFee + instructionsFee;
    return (priceFormatter(totalNum), totalNum);
  }

  checkFavorite() async {
    bool result = await favoriteService.checkExist(widget.food.uuid);
    setState(() {
      isFavorite = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 50), vsync: this)..repeat();
    checkFavorite();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteService newService = Provider.of<FavoriteService>(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: dimmension(20, context),
        ).copyWith(top: dimmension(120, context), bottom: dimmension(20, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(20, context)),
          border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: dimmension(100, context)),
                padding: EdgeInsets.all(dimmension(15, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MainDetails(price: selectedSize?.price ?? 0, food: widget.food),
                    const Separator(),
                    Text(
                      'ترکیبات',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: dimmension(15, context)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.food.details,
                        maxLines: 3,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const Separator(),
                    OptionsSection(
                      onQuantityChange: (int newQuan) {
                        setState(() {
                          quantity = newQuan;
                        });
                        widget.onDetailsUpdate(null, null, newQuan);
                      },
                      onExtrasChange: (List<ExtraModel> newExtras) {
                        setState(() {
                          extras = newExtras;
                        });
                        widget.onDetailsUpdate(newExtras, null, null);
                      },
                      onSizeChange: (SizeModel newSize) {
                        setState(() {
                          selectedSize = newSize;
                        });
                        widget.onDetailsUpdate(null, newSize, null);
                      },
                      food: widget.food,
                    ),
                    const Separator(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${calculateTotalPriceString()} تومان',
                          textDirection: TextDirection.rtl,
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium!.copyWith(color: yellowColor),
                        ),
                        Text('هزینه کل', style: Theme.of(context).textTheme.displayMedium),
                      ],
                    ),
                    SizedBox(height: dimmension(20, context)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: dimmension(-110, context),
              left: dimmension(80, context),
              child: RotationTransition(
                turns: _controller,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: dimmension(220, context),
                  height: dimmension(220, context),
                  padding: EdgeInsets.all(dimmension(10, context)),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: lightBgColor),
                  child: ClipOval(child: Image.network(widget.food.image, fit: BoxFit.cover)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () async {
                  bool res = await favoriteService.toggle(widget.food);
                  setState(() {
                    isFavorite = res;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(dimmension(10, context)),
                  padding: EdgeInsets.all(dimmension(10, context)),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: lightTextColor.withOpacity(0.1),
                        blurRadius: dimmension(5, context),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    size: dimmension(30, context),
                    color: isFavorite ? redColor : lightTextColor.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
