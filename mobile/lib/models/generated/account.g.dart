// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountFromJson(Map<String, dynamic> json) => AccountModel(
  uuid: json['uuid'] as String,
  phone: json['phone'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String?,
  profileImage: json['profile_image'] as String?,
  addresses:
      (json['addresses'] as List<dynamic>)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AccountToJson(AccountModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'phone': instance.phone,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'profile_image': instance.profileImage,
  'addresses': instance.addresses,
};

AccountShortInfo _$AccountShortInfoFromJson(Map<String, dynamic> json){
  print(json);
  return  AccountShortInfo(
    firstname: json['first_name'] as String,
    lastname: json['last_name'] as String,
    profile: json['profile_image'] as String,
  );
}

Map<String, dynamic> _$AccountShortInfoToJson(AccountShortInfo instance) => <String, dynamic>{
  'first_name': instance.firstname,
  'last_name': instance.lastname,
  'profile_image': instance.profile,
};
