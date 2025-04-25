import 'package:json_annotation/json_annotation.dart';

part 'generated/extra.g.dart';

@JsonSerializable()
class ExtraModel {
  final String uuid;
  final String name;
  final String icon;
  final int price;
  final int stack;
  final int quantity;

  ExtraModel({
    required this.uuid,
    required this.name,
    required this.icon,
    required this.price,
    this.stack = 0,
    this.quantity=0,
  });

  factory ExtraModel.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraToJson(this);
}