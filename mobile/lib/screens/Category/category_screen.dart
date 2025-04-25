import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/blocs/food_bloc.dart';
import 'package:food_app/components/food_list/foods_list_view.dart';
import 'package:food_app/components/food_list/shimmer_food_list.dart';
import 'package:food_app/models/category.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryModel category = Get.arguments['category'];

  final FoodBloc foodBloc = FoodBloc();

  Map<int, int> numbers = {};
  List<FoodModel> foods = [];

  @override
  void initState() {
    super.initState();
    foodBloc.getFoods(category: category.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(dimmension(20, context)),
        child: StreamBuilder(
          stream: foodBloc.subject.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null) {
                if ((snapshot.data.foods as List).isEmpty) {
                  return _buildNoItem(context);
                } else {
                  return Expanded(
                    child: FoodsListView(
                      foods: snapshot.data.foods,
                      onTap: (int index) {
                        Get.toNamed('food', arguments: {
                          'food': snapshot.data.foods[index],
                        });
                      },
                      eliminated: [],
                    ),
                  );
                }
              }
              if ((snapshot.data.foods as List).isEmpty) {
                return _buildNoItem(context);
              } else {
                return Expanded(
                  child: FoodsListView(
                    foods: snapshot.data.foods,
                    onTap: (int index) {
                      Get.toNamed('food', arguments: {
                        'food': snapshot.data.foods[index],
                      });
                    },
                    eliminated: [],
                  ),
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
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgColor,
      title: Text(
        category.title,
        style: Theme.of(context).textTheme.displayLarge,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.chevron_left_rounded,
          size: dimmension(30, context),
        ),
      ),
    );
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'غذایی پیدا نشد!',
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
