import 'package:flutter/material.dart';
import 'package:food_app/blocs/food_bloc.dart';
import 'package:food_app/blocs/restaurants_bloc.dart';
import 'package:food_app/components/food_list/foods_list_view.dart';
import 'package:food_app/components/food_list/shimmer_food_list.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/response_models/food_response.dart';
import 'package:food_app/services/favorite_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // final RestaurantBloc _bloc = RestaurantBloc();
  final FoodBloc _checkExistence = FoodBloc();
  List<FoodModel> copyFavorites = [];
  List<String> eliminated = [];

  FavoriteService favoriteService = getFavoriteService();

  _eliminateFoods(FoodResponse eliminateRes) {
    if (eliminateRes.error == null) {
      List<String> existUuids = eliminateRes.foods.map((item) => item.uuid).toList();
      for (var food in copyFavorites) {
        if (!existUuids.contains(food.uuid)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              eliminated.add(food.uuid);
            });
            favoriteService.removeFromFavorites(food);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    List<FoodModel> ordersList = getFavoriteService().favoriteList;
    setState(() {
      copyFavorites = List.of(ordersList);
    });
    // List<String> uuids = ordersList.map((e) => e.restaurant).toList();
    // _bloc.getRestaurants(uuids: uuids);
    _checkExistence.checkFoods(ordersList.map((e) => e.uuid).toList());
  }

  Future<void> onRefresh() async {
    FavoriteService favoriteService = getFavoriteService();
    favoriteService.getFoods();
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
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dimmension(20, context),
                  vertical: dimmension(30, context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'علاقه مندی ها',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: yellowColor,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(dimmension(20, context)).copyWith(
                    top: 0,
                  ),
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
                              foods: copyFavorites,
                              reverse: true,
                              useDismissible: true,
                              onDismissed: (FoodModel disFood) {
                                favoriteService.removeFromFavorites(disFood);
                                copyFavorites.remove(disFood);
                              },
                              onTap: (int index) {
                                Get.toNamed('food', arguments: {
                                  'food': copyFavorites[index],
                                });
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
                            foods: copyFavorites,
                            reverse: true,
                            useDismissible: true,
                            onDismissed: (FoodModel disFood) {
                              favoriteService.removeFromFavorites(disFood);
                              copyFavorites.remove(disFood);
                            },
                            onTap: (int index) {
                              Get.toNamed('food', arguments: {
                                'food': copyFavorites[index],
                              });
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
              SizedBox(height: dimmension(60, context)),
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
