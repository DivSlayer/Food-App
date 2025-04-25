
import 'package:food_app/models/address.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/restaurant_response.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<RestaurantResponse> _subject = BehaviorSubject<RestaurantResponse>();

  Future<RestaurantResponse> getCloseRestaurants(AddressModel address) async {
    RestaurantResponse response = await _resource.getCloseRestaurants(address);
    _subject.sink.add(response);
    return response;
  }

  Future<RestaurantResponse> getSingleRestaurants(String uuid) async {
    RestaurantResponse response = await _resource.getSingleRestaurants(uuid);
    _subject.sink.add(response);
    return response;
  }

  Future<RestaurantResponse> getRestaurants({List<String>? uuids})async{
    RestaurantResponse response = await _resource.getRestaurants(uuids);
    _subject.sink.add(response);
    return response;
  }
  dispose() {
    _subject.close();
  }

  BehaviorSubject<RestaurantResponse> get subject => _subject;
}
