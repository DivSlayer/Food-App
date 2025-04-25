import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/food_response.dart';
import 'package:rxdart/rxdart.dart';

class FoodBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<FoodResponse> _subject = BehaviorSubject<FoodResponse>();

  Future<FoodResponse> getSingleFood(String uuid) async {
    FoodResponse response = await _resource.getSingleFood(uuid);
    _subject.sink.add(response);
    return response;
  }

  Future<FoodResponse> checkFoods(List<String> uuids) async {
    FoodResponse response = await _resource.checkFoods(uuids);
    _subject.sink.add(response);
    return response;
  }

  Future<FoodResponse> getFoods({String? category}) async {
    FoodResponse response = await _resource.getFoods(category: category);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<FoodResponse> get subject => _subject;
}
