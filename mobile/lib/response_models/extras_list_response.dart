import 'package:food_app/models/category.dart';
import 'package:food_app/models/extra.dart';

class ExtraListResponse {
  final String? error;
  final List<ExtraModel> extras;

  ExtraListResponse({this.error, required this.extras});

  static ExtraListResponse withError(String error) {
    return ExtraListResponse(
      error: error,
      extras: [],
    );
  }

  static ExtraListResponse fromJson(Map<String, dynamic> json) {
    return ExtraListResponse(
      extras: (json['extras'] as List).map((e) => ExtraModel.fromJson(e)).toList(),
    );
  }
}
