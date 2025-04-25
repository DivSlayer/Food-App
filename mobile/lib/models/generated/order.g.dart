// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderFromJson(Map<String, dynamic> json) => OrderModel(
  uuid: json['uuid'] as String,
  food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
  status: const OrderStatusConverter().fromJson(json['status'] as String),
  createdTime: DateTime.parse(json['created_time'] as String),
  quantity: (json['quantity'] as num).toInt(),
  extras:
      (json['extras'] as List<dynamic>)
          .map((e) => ExtraModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  instructions:
      (json['instructions'] as List<dynamic>)
          .map((e) => InstructionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderToJson(OrderModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'food': instance.food,
  'status': instance.status.value,
  'created_time': instance.createdTime.toIso8601String(),
  'quantity': instance.quantity,
  'extras': jsonEncode(instance.extras.map((item)=>item.toJson()).toList()),
  'instructions': jsonEncode(instance.instructions.map((item)=>item.toJson()).toList()),
};
