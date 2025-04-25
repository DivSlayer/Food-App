

import 'package:food_app/models/account.dart';

class AccountResponse {
  final AccountModel? account;
  final String? error;

  AccountResponse({this.account, this.error});

  static AccountResponse fromJson(Map<String, dynamic> json) {
    return AccountResponse(account: AccountModel.fromJson(json));
  }

  static AccountResponse withError(String error) {
    return AccountResponse(error: error);
  }
}
