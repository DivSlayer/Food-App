

import 'package:food_app/models/banner_model.dart';

class BannerResponse {
  final List<BannerModel>? banners;
  final String? error;

  BannerResponse({this.banners, this.error});

  static BannerResponse fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      banners: (json['banners'] as List).map((e) => BannerModel.fromJson(e)).toList(),
    );
  }

  static BannerResponse withError(String error) {
    return BannerResponse(error: error);
  }
}
