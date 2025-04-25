import 'package:food_app/models/food.dart';
import 'package:food_app/models/restaurant.dart' show RestaurantModel;

class SearchModel {
  final FoodModel? food;
  final RestaurantModel? restaurant;

  SearchModel({required this.food, required this.restaurant});

  static SearchModel fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'food') {
      return SearchModel(food: FoodModel.fromJson(json['data']), restaurant: null);
    } else {
      return SearchModel(food: null, restaurant: RestaurantModel.fromJson(json['data']));
    }
  }
}
