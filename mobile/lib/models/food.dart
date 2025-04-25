import 'package:json_annotation/json_annotation.dart';
import 'category.dart';
import 'restaurant.dart';

part 'generated/food.g.dart';

@JsonSerializable()
class FoodModel {
  final String uuid;
  final String name;
  final String image;
  final String details;
  @JsonKey(name: 'preparation_time') final int preparationTime;
  final String rating;
  final List<SizeModel> sizes;
  final SizeModel? selectedSize;
  final RestaurantShortInfo restaurantInfo;
  final RestaurantModel? restaurant;
  @JsonKey(name: 'comments_count') final int commentsCount;
  @JsonKey(name: 'rating_count') final int ratingCount;
  final String category;

  FoodModel({
    required this.uuid,
    required this.name,
    required this.image,
    required this.details,
    required this.preparationTime,
    required this.rating,
    required this.sizes,
    required this.selectedSize,
    required this.restaurantInfo,
    required this.restaurant,
    required this.commentsCount,
    required this.ratingCount,
    required this.category,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);

  // CopyWith method
  FoodModel copyWith({
    String? uuid,
    String? name,
    String? image,
    String? details,
    int? preparationTime,
    String? rating,
    List<SizeModel>? sizes,
    SizeModel? selectedSize,
    RestaurantShortInfo? restaurantInfo,
    RestaurantModel? restaurant,
    int? commentsCount,
    int? ratingCount,
    String? category,
  }) {
    return FoodModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      image: image ?? this.image,
      details: details ?? this.details,
      preparationTime: preparationTime ?? this.preparationTime,
      rating: rating ?? this.rating,
      sizes: sizes ?? this.sizes,
      selectedSize: selectedSize ?? this.selectedSize,
      restaurantInfo: restaurantInfo ?? this.restaurantInfo,
      restaurant: restaurant ?? this.restaurant,
      commentsCount: commentsCount ?? this.commentsCount,
      ratingCount: ratingCount ?? this.ratingCount,
      category: category ?? this.category,
    );
  }
}


@JsonSerializable()
class SizeModel {
  final String name;
  final String details;
  final int price;

  SizeModel({
    required this.name,
    required this.details,
    required this.price,
  });
    factory SizeModel.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);
  Map<String, dynamic> toJson() => _$SizeToJson(this);
}
