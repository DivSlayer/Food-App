
import 'package:food_app/models/comment.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/comment_response.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc {
  final ServerResource _resource = ServerResource();
  final BehaviorSubject<CommentResponse> _subject = BehaviorSubject<CommentResponse>();

  Future<CommentResponse> getComments({required String commentFor}) async {
    CommentResponse response = await _resource.getComments(commentFor: commentFor);
    _subject.sink.add(response);
    return response;
  }

  Future<CommentResponse> addComment({required String commentFor,required CommentModel comment}) async {
    CommentResponse response = await _resource.addComment(commentFor: commentFor, comment: comment);
    _subject.sink.add(response);
    return response;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CommentResponse> get subject => _subject;
}
