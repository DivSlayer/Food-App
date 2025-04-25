import 'package:json_annotation/json_annotation.dart';

part 'generated/address.g.dart';

@JsonSerializable()
class AddressModel {
  final String uuid;
  final String title;
  final String name;
  final String phone;
  final String latitude;
  final String longitude;
  @JsonKey(name: 'brief_address')
  final String briefAddress;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'edited_at')
  final DateTime editedAt;

  AddressModel({
    required this.uuid,
    required this.title,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.briefAddress,
    required this.createdAt,
    required this.editedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  AddressModel copyWith({
    String? uuid,
    String? title,
    String? name,
    String? phone,
    String? latitude,
    String? longitude,
    String? briefAddress,
    DateTime? createdAt,
    DateTime? editedAt,
  }) {
    return AddressModel(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      briefAddress: briefAddress ?? this.briefAddress,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}
