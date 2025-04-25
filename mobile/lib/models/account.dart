import 'package:json_annotation/json_annotation.dart';
import 'address.dart';

part 'generated/account.g.dart';

@JsonSerializable()
class AccountModel {
  final String uuid;
  final String phone;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  final List<AddressModel> addresses;

  AccountModel({
    required this.uuid,
    required this.phone,
    required this.firstName,
    this.lastName,
    this.profileImage,
    required this.addresses,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class AccountShortInfo {
  final String firstname, lastname, profile;

  factory AccountShortInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountShortInfoFromJson(json);

  AccountShortInfo({required this.firstname, required this.lastname, required this.profile});

  Map<String, dynamic> toJson() => _$AccountShortInfoToJson(this);
}
