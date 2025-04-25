import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/search_response.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<SearchResponse> _subject = BehaviorSubject<SearchResponse>();

  Future<SearchResponse> search(String query) async {
    SearchResponse response = await _resource.search(query);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SearchResponse> get subject => _subject;
}
