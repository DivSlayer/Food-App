import 'package:food_app/models/address.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/models/instruction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/restaurant.g.dart';

@JsonSerializable()
class RestaurantModel {
  final String uuid;
  final String name;
  final String image;
  final String logo;
  final List<ExtraModel> extras;
  final List<InstructionModel> instructions;
  final List<List<num>> coverage;
  final List<AddressModel> addresses;
  final Map<String, List<FoodModel>>? cats;
  final double rating;
  final int commentsCount;

  RestaurantModel({
    required this.uuid,
    required this.name,
    required this.image,
    required this.logo,
    required this.coverage,
    required this.instructions,
    required this.extras,
    required this.addresses,
    required this.rating,
    required this.cats,
    required this.commentsCount,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}

@JsonSerializable()
class RestaurantShortInfo {
  final String uuid;
  final String name;
  final String? image;
  final String logo;

  RestaurantShortInfo({
    required this.uuid,
    required this.name,
    required this.image,
    required this.logo,
  });

  factory RestaurantShortInfo.fromJson(Map<String, dynamic> json) =>
      _$RestaurantShortInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantShortInfoToJson(this);
}
