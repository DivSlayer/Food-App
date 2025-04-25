// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantFromJson(Map<String, dynamic> json) => RestaurantModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  logo: json['logo'] as String,
  coverage:
      (json['coverage'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
          .toList(),
  extras: (json['extras'] as List<dynamic>).map((e) => ExtraModel.fromJson(e)).toList(),
  instructions:
      (json['instructions'] as List<dynamic>).map((e) => InstructionModel.fromJson(e)).toList(),
  addresses: (json['addresses'] as List).map((item) => AddressModel.fromJson(item)).toList(),
  cats:
      json.keys.contains('cats') && json['cats'] != null
          ? (json['cats'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).map((item) => FoodModel.fromJson(item)).toList(),
            ),
          )
          : null,
  rating:
      json['rating'].runtimeType == String
          ? double.parse(json['rating'] as String)
          : json['rating'] as double,

  commentsCount: json['comments_count'] as int,
);

Map<String, dynamic> _$RestaurantToJson(RestaurantModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'image': instance.image,
  'logo': instance.logo,
  'coverage': instance.coverage,
};

RestaurantShortInfo _$RestaurantShortInfoFromJson(Map<String, dynamic> json) => RestaurantShortInfo(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  logo: json['logo'] as String,
);

Map<String, dynamic> _$RestaurantShortInfoToJson(RestaurantShortInfo instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'image': instance.image,
  'logo': instance.logo,
};
