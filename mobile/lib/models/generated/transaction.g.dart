// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) => TransactionModel(
  serial: (json['serial'] as num).toInt(),
  totalPrice: (json['total_price'] as num).toInt(),
  totalDuration: (json['total_duration'] as num).toInt(),
  status: const TransactionStatusConverter().fromJson(json['status'] as String),
  paidTime: DateTime.parse(json['paid_time'] as String),
  deliveryCode: (json['delivery_code'] as num).toInt(),
  orders:
      (json['orders'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  changedAt: DateTime.parse(json['changed_at'] as String),
);

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) => <String, dynamic>{
  'serial': instance.serial,
  'total_price': instance.totalPrice,
  'total_duration': instance.totalDuration,
  'status': const TransactionStatusConverter().toJson(instance.status),
  'paid_time': instance.paidTime.toIso8601String(),
  'delivery_code': instance.deliveryCode,
  'orders': jsonEncode(instance.orders.map((item) => item.toJson()).toList()),
};
