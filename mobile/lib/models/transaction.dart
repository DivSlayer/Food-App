import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'order.dart';

part 'generated/transaction.g.dart';

enum TransactionStatus {
  pending('PE'),
  completed('CO'),
  canceled('CA'),
  accepted('AC'),
  declined('DE');

  final String value;
  const TransactionStatus(this.value);

  static TransactionStatus fromValue(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => TransactionStatus.pending,
    );
  }
}
@JsonSerializable(converters: [TransactionStatusConverter()])
class TransactionModel {
  final int serial;
  @JsonKey(name: 'total_price') final int totalPrice;
  @JsonKey(name: 'total_duration') final int totalDuration;
  final TransactionStatus status;
  @JsonKey(name: 'paid_time') final DateTime paidTime;
  @JsonKey(name: 'changed_at') final DateTime changedAt;
  @JsonKey(name: 'delivery_code') final int deliveryCode;
  final List<OrderModel> orders;

  TransactionModel({
    required this.serial,
    required this.totalPrice,
    required this.totalDuration,
    required this.status,
    required this.paidTime,
    required this.deliveryCode,
    required this.orders,
    required this.changedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

// Add this in transaction.dart
class TransactionStatusConverter implements JsonConverter<TransactionStatus, String> {
  const TransactionStatusConverter();

  @override
  TransactionStatus fromJson(String json) => TransactionStatus.fromValue(json);

  @override
  String toJson(TransactionStatus status) => status.value;
}