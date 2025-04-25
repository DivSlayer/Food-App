import 'package:json_annotation/json_annotation.dart';

part 'generated/category.g.dart';

@JsonSerializable()
class CategoryModel {
  final String uuid;
  final String title;
  final String icon;

  CategoryModel({
    required this.uuid,
    required this.title,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}


List<CategoryModel> defaultCategories = [
  CategoryModel(uuid: '1', title: 'پیتزا', icon: "assets/vectors/pizza.svg"),
  CategoryModel(uuid: '1', title: 'همبرگر', icon: "assets/vectors/hamburger.svg"),
  CategoryModel(uuid: '1', title: 'ساندویچ', icon: "assets/vectors/sandwich.svg"),
  CategoryModel(uuid: '1', title: 'کیک', icon: "assets/vectors/cake.svg"),
  CategoryModel(uuid: '1', title: 'کیک', icon: "assets/vectors/cake.svg"),
];
