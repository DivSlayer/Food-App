// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryFromJson(Map<String, dynamic> json) => CategoryModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$CategoryToJson(CategoryModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'icon': instance.icon,
    };
