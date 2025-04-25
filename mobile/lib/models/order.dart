import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'food.dart';
import 'instruction.dart';
import 'extra.dart';

part 'generated/order.g.dart';
enum OrderStatus {
  pending('PE'),
  cancelled('CA'),
  paid('PA');

  final String value;
  const OrderStatus(this.value);

  static OrderStatus fromValue(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
@JsonSerializable()
class OrderModel {
  final String uuid;
  final FoodModel food;
  final OrderStatus status;
  @JsonKey(name: 'created_time')
  final DateTime createdTime;
  final int quantity;
  final List<ExtraModel> extras;
  final List<InstructionModel> instructions;

  OrderModel({
    required this.uuid,
    required this.food,
    required this.status,
    required this.createdTime,
    required this.quantity,
    required this.extras,
    required this.instructions,
  });

  OrderModel copyWith({
    String? uuid,
    FoodModel? food,
    OrderStatus? status,
    DateTime? createdTime,
    int? quantity,
    List<ExtraModel>? extras,
    List<InstructionModel>? instructions,
  }) {
    return OrderModel(
      uuid: uuid ?? this.uuid,
      food: food ?? this.food,
      status: status ?? this.status,
      createdTime: createdTime ?? this.createdTime,
      quantity: quantity ?? this.quantity,
      extras: extras ?? List.from(this.extras),
      instructions: instructions ?? List.from(this.instructions),
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
// Add this in transaction.dart
class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) => OrderStatus.fromValue(json);

  @override
  String toJson(OrderStatus status) => status.value;
}