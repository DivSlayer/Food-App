// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodFromJson(Map<String, dynamic> json) => FoodModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  details: json['details'] as String,
  preparationTime: (json['preparation_time'] as num).toInt(),
  rating: json['rating'] as String,
  sizes:
      (json['sizes'] as List<dynamic>)
          .map((e) => SizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  selectedSize:
      json.keys.contains('selected_size') && json['selected_size'] != null
          ? SizeModel.fromJson(json['selected_size'])
          : null,
  restaurantInfo: RestaurantShortInfo.fromJson(json['restaurant_info'] as Map<String, dynamic>),
  restaurant:
      json['restaurant'] != null
          ? RestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>)
          : null,
  commentsCount: (json['comments_count'] as num).toInt(),
  ratingCount: (json['rating_count'] as num).toInt(),
  category: json['category'] as String,
);

Map<String, dynamic> _$FoodToJson(FoodModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'image': instance.image,
  'details': instance.details,
  'preparation_time': instance.preparationTime,
  'rating': instance.rating,
  'restaurant_uuid': instance.restaurantInfo.uuid,
  'comments_count': instance.commentsCount,
  'rating_count': instance.ratingCount,
  'category': instance.category,
};

SizeModel _$SizeFromJson(Map<String, dynamic> json) => SizeModel(
  name: json['name'] as String,
  details: json['details'] as String,
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$SizeToJson(SizeModel instance) => <String, dynamic>{
  'name': instance.name,
  'details': instance.details,
  'price': instance.price,
};
