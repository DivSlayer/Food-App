import 'package:flutter/material.dart';
import 'package:food_app/models/account.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/models/token_model.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/account_response.dart';
import 'package:food_app/response_models/token_response.dart';
import 'package:food_app/services/db.dart';
import 'package:get/get.dart';

class AccountService extends ChangeNotifier {
  AccountModel? _account;
  AddressModel? _activeAddress;
  final DatabaseService _db = DatabaseService();
  final ServerResource _serverResource = ServerResource();

  AccountModel? get account => _account;

  AddressModel? get activeAddress => _activeAddress;

  setAccount(AccountModel newAccount) {
    _account = newAccount;
    notifyListeners();
  }

  updateAddress(AddressModel newAddress) async {
    await _db.setAccount(_account!, newAddress.uuid);
    _activeAddress = newAddress;

    notifyListeners();
  }

  setAddress(List<AddressModel> addresses) async {
    AddressModel? defaultAddress = addresses.firstOrNull;
    String? defaultUUID = defaultAddress?.uuid;
    print("default address uuid is: $defaultUUID");
    Map<String,dynamic>? dbAccount = await _db.getAccount();
    String? dbAddressID = dbAccount?['active_address'];
    print("database address uuid is: $dbAddressID");
    // Find existing address or fall back to default
    _activeAddress = addresses.firstWhereOrNull((item) => item.uuid == dbAddressID) ?? defaultAddress;

    // Update DB only if no valid address was found
    if (defaultUUID != null && dbAddressID == null) {
      await _db.setAccount(_account!, defaultUUID);
    }

    notifyListeners();
  }

  clearAccount() {
    _account = null;
    notifyListeners();
  }

  Future<bool> updateDetails() async {
    try {
      TokenModel? token = await _db.getToken();
      print("Token is : $token");
      if (token != null) {
        AccountResponse accountResponse = await _serverResource.getUserDetails(token);
        if (accountResponse.error == null && accountResponse.account != null) {
          setAccount(accountResponse.account!);
          setAddress(accountResponse.account!.addresses);
          if (activeAddress != null) {
            _db.setAccount(accountResponse.account!, activeAddress!.uuid);
          } else if (accountResponse.account!.addresses.isNotEmpty) {
            _db.setAccount(accountResponse.account!, accountResponse.account!.addresses.first.uuid);
          }
          return true;
        }
        print(
          'here is the error: ${accountResponse.error == null} ${accountResponse.account != null}',
        );
        return false;
      }
      return false;
    } catch (e) {
      print('here is the error: $e');

      return false;
    }
  }

  Future<TokenResponse> login({required Map<String, dynamic> json}) async {
    TokenResponse tokenResponse = await _serverResource.loginUser(json: json);
    if (tokenResponse.error == null && tokenResponse.token != null) {
      bool tokenSaved = await _db.setToken(tokenResponse.token!.toJson());
      if (tokenSaved) {
        bool res = await updateDetails();
        return res ? tokenResponse : TokenResponse.withError("Failed to fetch details");
      }
    }
    return tokenResponse;
  }

  Future<bool> register({required Map<String, dynamic> json}) async {
    TokenResponse tokenResponse = await _serverResource.registerUser(json: json);
    if (tokenResponse.error == null && tokenResponse.token != null) {
      bool res = await updateDetails();
      return res;
    }
    return false;
  }

  Future<bool> addAddress({required Map<String, dynamic> json}) async {
    AddressModel? address = await _serverResource.addAddress(json);
    if (address != null) {
      account!.addresses.add(address);
    }
    bool res = await updateDetails();
    print(res);
    return res;
  }

  Future<bool> logOut() async {
    bool result = await _serverResource.logOut();
    if (result) {
      _account = null;
      _activeAddress = null;
      notifyListeners();
    }
    return result;
  }
}
