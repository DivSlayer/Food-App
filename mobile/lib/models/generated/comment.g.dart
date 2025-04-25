// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentFromJson(Map<String, dynamic> json) => CommentModel(
  uuid: json['uuid'] as String,
  content: json['content'] as String,
  commentFrom: AccountShortInfo.fromJson(json['comment_from'] as Map<String, dynamic>),
  publishedAt: DateTime.parse(json['published_at'] as String),
  isVerified: json['isVerified'] as bool,
  rating: (json['rating'] as num?)?.toDouble(),
  replies:
      (json['replies'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CommentToJson(CommentModel instance) => <String, dynamic>{
  'content': instance.content,
  'comment_from': instance.commentFrom,
  'published_at': instance.publishedAt.toIso8601String(),
  'rating': instance.rating,
};
