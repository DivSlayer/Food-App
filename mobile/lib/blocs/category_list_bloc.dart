
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/category_response.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<CategoryListResponse> _subject =
  BehaviorSubject<CategoryListResponse>();

  Future<CategoryListResponse> getCategories() async {
    CategoryListResponse response = await _resource.getCategoryList();
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CategoryListResponse> get subject => _subject;
}
