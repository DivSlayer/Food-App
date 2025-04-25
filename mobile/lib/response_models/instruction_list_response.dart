import 'package:food_app/models/category.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/instruction.dart';

class InstructionListResponse {
  final String? error;
  final List<InstructionModel> instructions;

  InstructionListResponse({this.error, required this.instructions});

  static InstructionListResponse withError(String error) {
    return InstructionListResponse(
      error: error,
      instructions: [],
    );
  }

  static InstructionListResponse fromJson(Map<String, dynamic> json) {
    return InstructionListResponse(
      instructions: (json['instructions'] as List).map((e) => InstructionModel.fromJson(e)).toList(),
    );
  }
}
