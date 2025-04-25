// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraModel _$ExtraFromJson(Map<String, dynamic> json) => ExtraModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  price: (json['price'] as num).toInt(),
  stack: (json['stack'] as num?)?.toInt() ?? 0,
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ExtraToJson(ExtraModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'icon': instance.icon,
  'price': instance.price,
  'stack': instance.stack,
  'quantity': instance.quantity,
};
