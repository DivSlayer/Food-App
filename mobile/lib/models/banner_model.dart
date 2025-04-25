import 'package:food_app/models/food.dart';

class BannerModel {
  final String uuid, content;
  final FoodModel food;

  BannerModel({
    required this.uuid,
    required this.content,
    required this.food,
  });

  static BannerModel fromJson(Map<String, dynamic> json) {
    return BannerModel(
      uuid: json['uuid'] as String,
      content: json['content'] as String,
      food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
    );
  }
}
