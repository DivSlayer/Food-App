import 'package:json_annotation/json_annotation.dart';
import 'account.dart';

part 'generated/comment.g.dart';

@JsonSerializable()
class CommentModel {
  final String uuid;
  final String content;
  @JsonKey(name: 'comment_from') final AccountShortInfo commentFrom;
  @JsonKey(name: 'published_at') final DateTime publishedAt;
  @JsonKey(name: 'isVerified') final bool isVerified;
  final double? rating;
  final List<CommentModel> replies;

  CommentModel({
    required this.uuid,
    required this.content,
    required this.commentFrom,
    required this.publishedAt,
    required this.isVerified,
    this.rating,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}