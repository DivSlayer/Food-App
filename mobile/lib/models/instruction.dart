import 'package:json_annotation/json_annotation.dart';

part 'generated/instruction.g.dart';

@JsonSerializable()
class InstructionModel {
  final String uuid;
  final String name;
  final String image;
  final int price;
  final int stack;
  final int quantity;

  InstructionModel({
    required this.uuid,
    required this.name,
    required this.image,
    required this.price,
    this.stack = 0,
    this.quantity = 0,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);
  Map<String, dynamic> toJson() => _$InstructionToJson(this);
}
