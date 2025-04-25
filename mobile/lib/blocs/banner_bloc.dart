
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/banner_response.dart';
import 'package:rxdart/rxdart.dart';

class BannerBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<BannerResponse> _subject =
  BehaviorSubject<BannerResponse>();

  Future<BannerResponse> getBanner() async {
    BannerResponse response = await _resource.getBanner();
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<BannerResponse> get subject => _subject;
}
