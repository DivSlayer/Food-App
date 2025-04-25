import 'package:food_app/models/restaurant.dart';

class RestaurantResponse {
  final String? error;
  final List<RestaurantModel> restaurants;

  RestaurantResponse({this.error, required this.restaurants});

  static RestaurantResponse withError(String error) {
    return RestaurantResponse(
      error: error,
      restaurants: [],
    );
  }

  static RestaurantResponse fromJson(Map<String, dynamic> json) {
    RestaurantResponse res = RestaurantResponse(
      restaurants: (json['restaurants'] as List).map((e) => RestaurantModel.fromJson(e)).toList(),
    );
    return res;
  }
}
