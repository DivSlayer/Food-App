// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressFromJson(Map<String, dynamic> json) => AddressModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      briefAddress: json['brief_address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: DateTime.parse(json['edited_at'] as String),
    );

Map<String, dynamic> _$AddressToJson(AddressModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'name': instance.name,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'brief_address': instance.briefAddress,
      'created_at': instance.createdAt.toIso8601String(),
      'edited_at': instance.editedAt.toIso8601String(),
    };
