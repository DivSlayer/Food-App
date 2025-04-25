import 'package:flutter/material.dart';
import 'package:food_app/blocs/food_bloc.dart';
import 'package:food_app/blocs/restaurants_bloc.dart';
import 'package:food_app/components/buttons/yellow_btn.dart';
import 'package:food_app/components/count_down_timer.dart';
import 'package:food_app/components/food_list/foods_list_view.dart';
import 'package:food_app/components/food_list/shimmer_food_list.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/response_models/food_response.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // final RestaurantBloc _bloc = RestaurantBloc();
  final FoodBloc _checkExistence = FoodBloc();
  List<OrderModel> copyOrders = [];
  List<String> eliminated = [];
  OrderService orderService = getOrderService();

  _eliminateFoods(FoodResponse eliminateRes) {
    if (eliminateRes.error == null) {
      List<String> existUuids = eliminateRes.foods.map((item) => item.uuid).toList();
      for (var order in copyOrders) {
        if (!existUuids.contains(order.food.uuid)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              eliminated.add(order.food.uuid);
            });
            orderService.removeOrder(order.uuid, order.food.uuid);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    List<OrderModel> ordersList = getOrderService().orders;
    setState(() {
      copyOrders = List.of(ordersList);
    });
    // List<String> uuids = ordersList.map((e) => e.food.restaurant).toList();
    // _bloc.getRestaurants(uuids: uuids);
    _checkExistence.checkFoods(ordersList.map((e) => e.food.uuid).toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onRefresh() async {
    OrderService orderService = getOrderService();

    orderService.loadOrders();
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CheckMarkIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dimmension(20, context),
                        vertical: dimmension(15, context),
                      ).copyWith(bottom: dimmension(30, context)),
                      child: Text(
                        'سبد خرید',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge!.copyWith(color: yellowColor),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(dimmension(20, context)).copyWith(top: 0),
                        child: StreamBuilder(
                          stream: _checkExistence.subject.stream,
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.error != null) {
                                if ((snapshot.data.foods as List).isEmpty) {
                                  return _buildNoItem(context);
                                } else {
                                  _eliminateFoods(snapshot.data as FoodResponse);
                                  return FoodsListView(
                                    foods: copyOrders.map((e) => e.food).toList(),
                                    onTap: (int index) {
                                      Get.toNamed(
                                        'receipt',
                                        arguments: {
                                          'food': copyOrders[index].food,
                                          'order': copyOrders[index],
                                        },
                                      );
                                    },
                                    useDismissible: true,
                                    onDismissed: (dismissedFood) {
                                      List<FoodModel> foodsList =
                                          copyOrders.map((e) => e.food).toList();
                                      int index = foodsList.indexOf(dismissedFood);
                                      orderService.removeOrder(
                                        copyOrders[index].uuid,
                                        copyOrders[index].food.uuid,
                                      );
                                      copyOrders.removeWhere(
                                        (item) => item.uuid == copyOrders[index].uuid,
                                      );
                                    },
                                    eliminated: eliminated,
                                  );
                                }
                              }
                              if ((snapshot.data.foods as List).isEmpty) {
                                return _buildNoItem(context);
                              } else {
                                _eliminateFoods(snapshot.data as FoodResponse);
                                return FoodsListView(
                                  foods: copyOrders.map((e) => e.food).toList(),
                                  onTap: (int index) {
                                    Get.toNamed(
                                      'receipt',
                                      arguments: {
                                        'food': copyOrders[index].food,
                                        'order': copyOrders[index],
                                      },
                                    );
                                  },
                                  useDismissible: true,
                                  onDismissed: (dismissedFood) {
                                    List<FoodModel> foodsList =
                                        copyOrders.map((e) => e.food).toList();
                                    int index = foodsList.indexOf(dismissedFood);
                                    orderService.removeOrder(
                                      copyOrders[index].uuid,
                                      copyOrders[index].food.uuid,
                                    );
                                    copyOrders.removeWhere(
                                      (item) => item.uuid == copyOrders[index].uuid,
                                    );
                                  },
                                  eliminated: eliminated,
                                );
                              }
                            } else if (snapshot.hasError) {
                              return _buildNoItem(context);
                            } else {
                              return const ShimmerFoodsList(length: 5);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: dimmension(100, context)),
                  ],
                ),
              ),
              copyOrders.isNotEmpty
                  ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: dimmension(55, context),
                      width: MediaQuery.of(context).size.width - dimmension(60, context),
                      margin: EdgeInsets.symmetric(
                        horizontal: dimmension(30, context),
                      ).copyWith(bottom: dimmension(140, context)),
                      child: YellowBtn(
                        title: 'پرداخت',
                        onTap: () {
                          Get.offNamed('payment', arguments: {'orders': copyOrders});
                        },
                      ),
                    ),
                  )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'سبد خرید خالی است!',
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
