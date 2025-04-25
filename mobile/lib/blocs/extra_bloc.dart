
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/category_response.dart';
import 'package:rxdart/rxdart.dart';

import '../response_models/extras_list_response.dart';

class ExtrasListBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<ExtraListResponse> _subject =
  BehaviorSubject<ExtraListResponse>();

  Future<ExtraListResponse> getExtras(String restaurant) async {
    ExtraListResponse response = await _resource.getExtrasList(restaurant);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ExtraListResponse> get subject => _subject;
}
