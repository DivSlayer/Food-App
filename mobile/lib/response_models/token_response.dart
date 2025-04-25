import 'package:food_app/models/token_model.dart';

class TokenResponse {
  final TokenModel? token;
  final String? error;

  TokenResponse({this.token, this.error});

  static TokenResponse fromJson(Map<String, dynamic> json) {
    return TokenResponse(token: TokenModel.fromJson(json));
  }

  static TokenResponse withError(String error) {
    return TokenResponse(error: error);
  }
}
