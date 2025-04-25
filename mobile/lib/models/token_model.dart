class TokenModel {
  final String refresh, access;

  TokenModel({required this.refresh, required this.access});

  static TokenModel fromJson(Map<String, dynamic> json) {
    return TokenModel(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'refresh': refresh, 'access': access};
  }
}
