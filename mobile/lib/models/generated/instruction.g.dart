// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructionModel _$InstructionFromJson(Map<String, dynamic> json) => InstructionModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  price: (json['price'] as num).toInt(),
  stack: (json['stack'] as num?)?.toInt() ?? 0,
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$InstructionToJson(InstructionModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'image': instance.image,
  'price': instance.price,
  'stack': instance.stack,
  'quantity': instance.quantity,
};
