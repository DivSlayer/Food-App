import 'package:food_app/models/search_model.dart';

class SearchResponse {
  final String? error;
  final List<SearchModel> objects;

  SearchResponse({this.error, required this.objects});

  static SearchResponse withError(String error) {
    return SearchResponse(
      error: error,
      objects: [],
    );
  }

  static SearchResponse fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      objects: (json['results'] as List).map((e) => SearchModel.fromJson(e)).toList(),
    );
  }
}
