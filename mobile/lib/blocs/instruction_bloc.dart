
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/category_response.dart';
import 'package:food_app/response_models/instruction_list_response.dart';
import 'package:rxdart/rxdart.dart';

import '../response_models/extras_list_response.dart';

class InstructionListBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<InstructionListResponse> _subject =
  BehaviorSubject<InstructionListResponse>();

  Future<InstructionListResponse> getExtras(String restaurant) async {
    InstructionListResponse response = await _resource.getInstructionsList(restaurant);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<InstructionListResponse> get subject => _subject;
}
