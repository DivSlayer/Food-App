import 'package:food_app/models/category.dart';

class CategoryListResponse {
  final String? error;
  final List<CategoryModel> categories;

  CategoryListResponse({this.error, required this.categories});

  static CategoryListResponse withError(String error) {
    return CategoryListResponse(
      error: error,
      categories: [],
    );
  }

  static CategoryListResponse fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      categories: (json['categories'] as List).map((e) => CategoryModel.fromJson(e)).toList(),
    );
  }
}
