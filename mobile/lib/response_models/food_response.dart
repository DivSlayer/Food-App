import 'package:food_app/models/food.dart';

class FoodResponse {
  final String? error;
  final List<FoodModel> foods;

  FoodResponse({this.error, required this.foods});

  static FoodResponse withError(String error) {
    return FoodResponse(
      error: error,
      foods: [],
    );
  }

  static FoodResponse fromJson(Map<String, dynamic> json) {
    return FoodResponse(
      foods: (json['foods'] as List).map((e) => FoodModel.fromJson(e)).toList(),
    );
  }
}
