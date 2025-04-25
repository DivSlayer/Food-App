import 'package:food_app/models/comment.dart';

class CommentResponse {
  final String? error;
  final List<CommentModel> comments;

  CommentResponse({this.error, required this.comments});

  static CommentResponse withError(String error) {
    return CommentResponse(
      error: error,
      comments: [],
    );
  }

  static CommentResponse fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      comments: (json['comments'] as List).map((e) => CommentModel.fromJson(e)).toList(),
    );
  }
}
