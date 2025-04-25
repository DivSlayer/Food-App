import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/token_response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<TokenResponse> _subject =
  BehaviorSubject<TokenResponse>();

  Future<TokenResponse> loginUser(Map<String, dynamic> json) async {
    TokenResponse response = await _resource.loginUser(json: json);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<TokenResponse> get subject => _subject;
}
