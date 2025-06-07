import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/models/comment.dart';
import 'package:food_app/models/token_model.dart';
import 'package:food_app/models/transaction.dart';
import 'package:food_app/resource/links.dart';
import 'package:food_app/response_models/account_response.dart';
import 'package:food_app/response_models/banner_response.dart';
import 'package:food_app/response_models/category_response.dart';
import 'package:food_app/response_models/comment_response.dart';
import 'package:food_app/response_models/extras_list_response.dart';
import 'package:food_app/response_models/food_response.dart';
import 'package:food_app/response_models/instruction_list_response.dart';
import 'package:food_app/response_models/restaurant_response.dart';
import 'package:food_app/response_models/search_response.dart';
import 'package:food_app/response_models/splash_response.dart';
import 'package:food_app/response_models/token_response.dart';
import 'package:food_app/response_models/transaction_response.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/services/db.dart';

class ServerResource {
  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(minutes: 2),
  );
  Dio _dio = Dio();

  ServerResource() {
    _dio = Dio(options);
  }

  final DatabaseService _db = DatabaseService();

  Future<bool> updateToken() async {
    String link = "${Links.updateTokenURL}/";

    TokenModel? token = await _db.getToken();
    if (token != null) {
      FormData formData = FormData.fromMap({'refresh': token.refresh});
      Response response = await _dio.post(link, data: formData);
      print("refresh status: ${response.statusCode}");
      print("response data: ${response.data}");
      if (response.statusCode == 200) {
        await _db.setToken({'access': response.data['access'] as String, 'refresh': token.refresh});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<AccountResponse> getUserDetails(TokenModel token) async {
    String link = Links.getUserURL;

    _dio.options.headers['Authorization'] = "Bearer ${token.access}";
    Response response = await _dio.get(link);
    if (response.statusCode == 200) {
      AccountResponse res = AccountResponse.fromJson(response.data);
      print(response.data);
      return res;
    }
    return AccountResponse.withError("Something went wrong!");
  }

  Future<TokenResponse> loginUser({required Map<String, dynamic> json}) async {
    try {
      String link = Links.loginURL;
      FormData formData = FormData.fromMap(json);
      Response response = await _dio.post(link, data: formData);

      // Check if the response status code is 200
      if (response.statusCode == 200) {
        TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
        print("Token response from login page: ${tokenResponse.token}");
        bool result = await _db.setToken(tokenResponse.token?.toJson() ?? {});
        print("Setting token to database: $result");
        if (result) {
          return TokenResponse.fromJson(response.data);
        } else {
          return TokenResponse.withError('خطایی در ثبت رخ داده است!');
        }
      } else {
        // Handle non-200 responses
        String error = response.data['error'] ?? 'خطایی در ورود رخ داده است!';
        return TokenResponse.withError(error);
      }
    } catch (e) {
      if (e is DioException) {
        // Handle _dioError specifically
        if (e.response != null) {
          // Check the status code from the response
          String error = e.response!.data['error'] ?? 'خطایی در ورود رخ داده است!';
          return TokenResponse.withError(error);
        }
      }
      // Handle other exceptions
      print(e);
      return TokenResponse.withError('خطایی رخ داده است!');
    }
  }

  Future<TokenResponse> registerUser({required Map<String, dynamic> json}) async {
    String link = Links.registerURL;
    FormData formData = FormData.fromMap(json);

    try {
      Response response = await _dio.post(link, data: formData);

      // Check if the response status code is 200
      if (response.statusCode == 200) {
        TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
        bool result = await _db.setToken(tokenResponse.token?.toJson() ?? {});
        if (result) {
          return TokenResponse.fromJson(response.data);
        } else {
          return TokenResponse.withError('خطایی در ورود رخ داده است!');
        }
      } else {
        // Handle non-200 responses
        String error = response.data['error'] ?? 'خطایی در ورود رخ داده است!';
        return TokenResponse.withError(error);
      }
    } catch (e) {
      if (e is DioException) {
        // Handle _dioError specifically
        if (e.response != null) {
          // Check the status code from the response
          String error = e.response!.data['error'] ?? 'خطایی در ورود رخ داده است!';
          return TokenResponse.withError(error);
        }
      }
      // Handle other exceptions
      print(e);
      return TokenResponse.withError('خطایی رخ داده است!');
    }
  }

  Future<bool> logOut() async {
    _db.clearTable(Tables.token);
    // delete account from _db
    int lastTokenID = await _db.getLastID(table: Tables.token);
    late bool tokenResult, _;
    if (lastTokenID != 0) {
      tokenResult = await _db.deleteItem(table: Tables.token, id: lastTokenID);
    } else {
      tokenResult = true;
    }
    return tokenResult;
  }

  Future<SplashResponse> splashCheck() async {
    // Server check
    String serverCheckLink = Links.serverCheckURL;
    try {
      await _dio.get(serverCheckLink);
      return SplashResponse();
    } catch (error) {
      return SplashResponse(serverError: 'خطا در ارتباط با سرور!');
    }
    // User check
  }

  Future<AddressModel?> addAddress(Map<String, dynamic> json) async {
    String link = Links.addAddressURL;
    FormData formData = FormData.fromMap(json);
    try {
      TokenModel? token = await _db.getToken();
      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<TokenModel?> checkToken() async {
    try {
      TokenModel? token = await _db.getToken();
      if (token != null) {
        bool updated = await updateToken();
        if (updated) {
          token = await _db.getToken();
          return token;
        } else {
          await _db.clearTable(Tables.token);
          return null;
        }
      }
      return null;
    } catch (e) {
      print("Token check failed: $e");
      return null;
    }
  }

  Future<SplashResponse> userCheck() async {
    try {
      TokenModel? token = await checkToken();
      print("token checked: $token");
      if (token != null) {
        AccountService accountService = getAccountService();
        bool res = await accountService.updateDetails();
        print("account service res: $res");
        if (res) {
          return SplashResponse();
        }
        return SplashResponse(userError: "Token not Valid");
      }
      return SplashResponse(userError: "No Token!");
    } catch (e) {
      rethrow;

      return SplashResponse(userError: "Something went wrong!");
    }
  }

  Future<CategoryListResponse> getCategoryList() async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.categoriesListURL;

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        CategoryListResponse res = CategoryListResponse.fromJson(response.data);
        return res;
      }
      return CategoryListResponse.withError('something went wrong');
    } catch (e) {
      return CategoryListResponse.withError('something went wrong');
    }
  }

  Future<ExtraListResponse> getExtrasList(String restaurant) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.extrasListURL(restaurant);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        ExtraListResponse res = ExtraListResponse.fromJson(response.data);
        return res;
      }
      return ExtraListResponse.withError('something went wrong');
    } catch (e) {
      return ExtraListResponse.withError('something went wrong');
    }
  }

  Future<InstructionListResponse> getInstructionsList(String restaurant) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.extrasListURL(restaurant);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        InstructionListResponse res = InstructionListResponse.fromJson(response.data);
        return res;
      }
      return InstructionListResponse.withError('something went wrong');
    } catch (e) {
      return InstructionListResponse.withError('something went wrong');
    }
  }

  Future<RestaurantResponse> getCloseRestaurants(AddressModel address) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.closeRestaurantURL;

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      FormData formData = FormData.fromMap({"lat": address.latitude, 'long': address.longitude});
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        RestaurantResponse res = RestaurantResponse.fromJson(response.data);
        return res;
      }
      return RestaurantResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return RestaurantResponse.withError('something went wrong');
    }
  }

  Future<RestaurantResponse> getSingleRestaurants(String uuid) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.singleRestaurantURL(uuid);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        RestaurantResponse res = RestaurantResponse.fromJson(response.data);
        return res;
      }
      return RestaurantResponse.withError('something went wrong');
    } catch (e) {
      return RestaurantResponse.withError('something went wrong');
    }
  }

  Future<FoodResponse> getSingleFood(String uuid) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.singleFoodURL(uuid);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        FoodResponse res = FoodResponse.fromJson(response.data);
        return res;
      }
      return FoodResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return FoodResponse.withError('something went wrong');
    }
  }

  Future<FoodResponse> getFoods({String? category}) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = category != null ? "${Links.getFoods}?category=$category" : Links.getFoods;

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        FoodResponse res = FoodResponse.fromJson(response.data);
        return res;
      }
      return FoodResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return FoodResponse.withError('something went wrong');
    }
  }

  Future<CommentResponse> getComments({required String commentFor}) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.commentsURL(commentFor);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        print(jsonEncode(response.data));
        CommentResponse res = CommentResponse.fromJson(response.data);
        return res;
      }
      return CommentResponse.withError('something went wrong');
    } catch (e) {
      rethrow;
      return CommentResponse.withError('something went wrong');
    }
  }

  Future<CommentResponse> addComment({
    required String commentFor,
    required CommentModel comment,
  }) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.commentsURL(commentFor);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      FormData formData = FormData.fromMap(comment.toJson());
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        CommentResponse res = CommentResponse.fromJson(response.data);
        return res;
      }
      return CommentResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return CommentResponse.withError('something went wrong');
    }
  }

  Future<FoodResponse> checkFoods(List<String> uuids) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.checkFoods;

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      FormData formData = FormData.fromMap({'uuids': jsonEncode(uuids)});
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        FoodResponse res = FoodResponse.fromJson(response.data);
        return res;
      }
      return FoodResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return FoodResponse.withError('something went wrong');
    }
  }

  Future<RestaurantResponse> getRestaurants(List<String>? uuids) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.singleRestaurantURL("");

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      FormData formData = FormData.fromMap({
        "uuids": uuids != null ? json.encode(uuids) : json.encode([]),
      });
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        RestaurantResponse res = RestaurantResponse.fromJson(response.data);
        return res;
      }
      return RestaurantResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return RestaurantResponse.withError('something went wrong');
    }
  }

  Future<TransactionsResponse> getTransaction(List<TransactionStatus> status) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.transactionsURL;
      if (status.isNotEmpty) {
        link += "?status=${status.join(',')}";
      }

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        TransactionsResponse res = TransactionsResponse.fromJson(response.data);
        return res;
      }
      return TransactionsResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return TransactionsResponse.withError('something went wrong');
    }
  }

  Future<TransactionsResponse> addTransaction(
    Map<String, dynamic> json,
    AddressModel address,
  ) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = "${Links.transactionsURL}/";

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      json.addAll({

      });
      FormData formData = FormData.fromMap(json);
      Response response = await _dio.post(link, data: formData);
      if (response.statusCode == 200) {
        TransactionsResponse res = TransactionsResponse.fromJson(response.data);
        return res;
      }
      return TransactionsResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return TransactionsResponse.withError('something went wrong');
    }
  }

  Future<TransactionsResponse> removeTransaction(int serial) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = "${Links.transactionsURL}/delete/$serial";

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.delete(link);
      if (response.statusCode == 200) {
        TransactionsResponse res = TransactionsResponse.fromJson(response.data);
        return res;
      }
      return TransactionsResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return TransactionsResponse.withError('something went wrong');
    }
  }

  Future<SearchResponse> search(String query) async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.searchURL(query);

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        SearchResponse res = SearchResponse.fromJson(response.data);
        return res;
      }
      return SearchResponse.withError('something went wrong');
    } catch (e) {
      print(e);
      return SearchResponse.withError('something went wrong');
    }
  }

  Future<BannerResponse> getBanner() async {
    try {
      TokenModel? token = await _db.getToken();
      String link = Links.bannerURL;

      _dio.options.headers['Authorization'] = "Bearer ${token!.access}";
      Response response = await _dio.get(link);
      if (response.statusCode == 200) {
        BannerResponse res = BannerResponse.fromJson(response.data);
        print(res);
        return res;
      }
      return BannerResponse.withError('something went wrong');
    } catch (e) {
      return BannerResponse.withError('something went wrong');
    }
  }
}
