import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/blocs/food_bloc.dart';
import 'package:food_app/components/buttons/transparent_btn.dart';
import 'package:food_app/components/buttons/yellow_btn.dart';
import 'package:food_app/components/number_counter.dart';
import 'package:food_app/components/separator.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/models/instruction.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/screens/Food/components/details_container.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/loading_widget.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:food_app/utils/snack.dart';
import 'package:get/get.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FoodModel argumentsFood = Get.arguments['food'];
  final FoodBloc _foodBloc = FoodBloc();

  List<InstructionModel> selectedInstructions = [];
  List<ExtraModel> selectedExtras = [];
  SizeModel? size;
  int quantity = 1;
  int totalFee = 0;

  bool _isAddingToOrder = false;
  List<InstructionModel> _selectedInstructions = [];
  Map<InstructionModel, int> _instructionsQuantity = {};

  void detailsUpdate({List<ExtraModel>? newExtras, SizeModel? newSize, int? newQuan}) {
    if (newExtras != null) {
      setState(() {
        selectedExtras = newExtras;
      });
    }
    if (newSize != null) {
      setState(() {
        size = newSize;
      });
    }
    if (newQuan != null) {
      setState(() {
        quantity = newQuan;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _foodBloc.getSingleFood(argumentsFood.uuid);
  }

  void _showModalBottomSheet(BuildContext context, FoodModel food) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState2) {
            Map<InstructionModel, int> instructionsQuantity = Map.from(_instructionsQuantity);
            List<InstructionModel> selectedInstructions = List.from(_selectedInstructions);
            return Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(dimmension(20, context)),
                  topRight: Radius.circular(dimmension(20, context)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimmension(20, context),
                    ).copyWith(top: dimmension(20, context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: dimmension(30, context),
                            color: textColor,
                          ),
                        ),
                        Text(
                          'اضافه کردن دستور پخت',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Container(width: dimmension(40, context)),
                      ],
                    ),
                  ),
                  Separator(marginSize: dimmension(20, context)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
                      child: ListView.builder(
                        itemCount: food.restaurant!.instructions.length,
                        itemBuilder:
                            (context, index) => Container(
                              padding: EdgeInsets.all(dimmension(20, context)),
                              margin: EdgeInsets.only(bottom: dimmension(20, context)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimmension(20, context)),
                                border: Border.all(width: 1, color: borderColor.withOpacity(0.5)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: dimmension(100, context),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                food.restaurant!.instructions[index].name,
                                                style: Theme.of(context).textTheme.displayMedium,
                                              ),
                                              SizedBox(height: dimmension(10, context)),
                                              Text(
                                                "به ازای هر عدد",
                                                style: Theme.of(context).textTheme.displaySmall!
                                                    .copyWith(fontSize: dimmension(12, context)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              NumberCounter(
                                                currentNumbers:
                                                    instructionsQuantity[food
                                                        .restaurant!
                                                        .instructions[index]] ??
                                                    0,
                                                onAdd: () {
                                                  setState2(() {
                                                    instructionsQuantity[food
                                                            .restaurant!
                                                            .instructions[index]] =
                                                        (instructionsQuantity[food
                                                                .restaurant!
                                                                .instructions[index]] ??
                                                            0) +
                                                        1;
                                                    selectedInstructions.add(
                                                      food.restaurant!.instructions[index],
                                                    );
                                                  });
                                                  setState(() {
                                                    _instructionsQuantity[food
                                                            .restaurant!
                                                            .instructions[index]] =
                                                        (_instructionsQuantity[food
                                                                .restaurant!
                                                                .instructions[index]] ??
                                                            0) +
                                                        1;
                                                    _selectedInstructions.add(
                                                      food.restaurant!.instructions[index],
                                                    );
                                                  });
                                                },
                                                onMinus: () {
                                                  setState2(() {
                                                    instructionsQuantity[food
                                                            .restaurant!
                                                            .instructions[index]] =
                                                        (instructionsQuantity[food
                                                                .restaurant!
                                                                .instructions[index]] ??
                                                            0) -
                                                        1;
                                                    selectedInstructions.remove(
                                                      food.restaurant!.instructions[index],
                                                    );
                                                  });
                                                  setState(() {
                                                    _instructionsQuantity[food
                                                            .restaurant!
                                                            .instructions[index]] =
                                                        (_instructionsQuantity[food
                                                                .restaurant!
                                                                .instructions[index]] ??
                                                            0) -
                                                        1;
                                                    _selectedInstructions.remove(
                                                      food.restaurant!.instructions[index],
                                                    );
                                                  });
                                                },
                                              ),
                                              Text(
                                                '${priceFormatter(food.restaurant!.instructions[index].price)} تومان',
                                                textDirection: TextDirection.rtl,
                                                style: Theme.of(context).textTheme.displaySmall!
                                                    .copyWith(color: yellowColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: dimmension(20, context)),
                                  Container(
                                    padding: EdgeInsets.all(dimmension(10, context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(dimmension(10, context)),
                                      color: lightBgColor,
                                    ),
                                    child: SvgPicture.network(
                                      food.restaurant!.instructions[index].image,
                                      height: dimmension(50, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                  Container(
                    height: dimmension(80, context),
                    padding: EdgeInsets.symmetric(
                      vertical: dimmension(10, context),
                      horizontal: dimmension(20, context),
                    ),
                    child: YellowBtn(
                      title: 'اضافه کردن به سفارش',
                      onTap: () {
                        setState(() {
                          _selectedInstructions = selectedInstructions;
                          _instructionsQuantity = instructionsQuantity;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> onRefresh() async {
    _foodBloc.getSingleFood(argumentsFood.uuid);
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
        toolbarHeight: 0,
      ),
      bottomNavigationBar: Container(height: 0),
      body: SafeArea(
        child: CheckMarkIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: _foodBloc.subject.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null) {
                    if ((snapshot.data.foods as List).isEmpty) {
                      return _buildNoItem(context);
                    } else {
                      return _buildContent(context, snapshot.data.foods[0]);
                    }
                  }
                  if ((snapshot.data.foods as List).isEmpty) {
                    return _buildNoItem(context);
                  } else {
                    return _buildContent(context, snapshot.data.foods[0]);
                  }
                } else if (snapshot.hasError) {
                  return _buildNoItem(context);
                } else {
                  return _buildLoadingPage();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FoodModel food) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < food.restaurant!.instructions.length; i++) {
        int count = _selectedInstructions.fold(
          0,
          (count, element) => count + (element == food.restaurant!.instructions[i] ? 1 : 0),
        );
        setState(() {
          _instructionsQuantity[food.restaurant!.instructions[i]] = count;
        });
      }
    });
    OrderService orderService = getOrderService();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: dimmension(10, context)),
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: textColor,
                size: dimmension(35, context),
              ),
            ),
          ),
          DetailsContainer(
            instructions: _selectedInstructions,
            food: food,
            onDetailsUpdate:
                (List<ExtraModel>? newExtras, SizeModel? newSize, int? neqQuan) =>
                    detailsUpdate(newExtras: newExtras, newSize: newSize, newQuan: neqQuan),
          ),
          Container(
            height: dimmension(60, context),
            margin: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
            ).copyWith(bottom: dimmension(20, context)),
            child: LayoutBuilder(
              builder:
                  (context, constraints) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (constraints.maxWidth - dimmension(20, context)) / 2,
                        child: TransparentBtn(
                          title: 'دستور پخت',
                          onTap: () {
                            _showModalBottomSheet(context, food);
                          },
                        ),
                      ),
                      SizedBox(
                        width: (constraints.maxWidth - dimmension(20, context)) / 2,
                        child: YellowBtn(
                          title: 'اضافه به سبد',
                          isSending: _isAddingToOrder,
                          onTap: () {
                            if (_isAddingToOrder) return;
                            setState(() {
                              _isAddingToOrder = true;
                            });
                            orderService
                                .addOrder(
                                  food: food,
                                  quantity: quantity,
                                  extras: selectedExtras,
                                  instructions: selectedInstructions,
                                  selectedSize: size ?? food.sizes[0],
                                )
                                .then((_) {
                                  setState(() {
                                    _isAddingToOrder = false;
                                  });
                                  Navigator.popAndPushNamed(context, 'home');
                                })
                                .catchError((error) {
                                  setState(() {
                                    _isAddingToOrder = false;
                                  });
                                  showSnack('خطایی رخ داده است!', context, color: redColor);
                                });
                          },
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          SizedBox(height: dimmension(40, context)),
        ],
      ),
    );
  }

  int calculateTotalPrice() {
    int extrasFee = selectedExtras
        .map((extra) => extra.price)
        .toList()
        .fold(0, (previous, current) => previous + current);
    int instructionsFee = selectedInstructions
        .map((instruction) => instruction.price)
        .toList()
        .fold(0, (previous, current) => previous + current);
    int quantityFee = quantity * (size?.price ?? 0);
    int totalNum = quantityFee + extrasFee + instructionsFee;
    return totalNum;
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'غذایی وجود ندارد!',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: lightTextColor),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(child: LoadingWidget(loadColor: yellowColor, size: dimmension(40, context))),
    );
  }
}
