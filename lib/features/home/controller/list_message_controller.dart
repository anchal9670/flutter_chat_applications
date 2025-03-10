import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/features/home/repo/list_message_repo.dart';
import 'package:chat_app/models/list_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listOfMessageControllerProvider =
    StateNotifierProvider<ComplaintController, List<ListOfMessage>>((ref) {
  final complaintRepo = ref.read(listMessageRepoProvider);
  return ComplaintController(
      complaint: ListOfMessage(), repo: complaintRepo, ref: ref);
});

class ComplaintController extends StateNotifier<List<ListOfMessage>> {
  final ListMessageRepo _repo;
  final Ref _ref;

  ComplaintController(
      {required ListOfMessage complaint,
      required ListMessageRepo repo,
      required Ref ref})
      : _ref = ref,
        _repo = repo,
        super([]);
  Future<void> getListOfMessage() async {
    try {
      final result = await _repo.listOfMessage();
      result.fold(
        (failure) {
          log('Failure: $failure');
        },
        (response) {
          final data = jsonDecode(response.body);
          final messageList = data['data'] as List;
          final messages = messageList
              .map((message) => ListOfMessage.fromJson(message))
              .toList();
          state = messages;
        },
      );
    } catch (e, stacktrace) {
      log('Error: $e');
      log('Stacktrace: $stacktrace');
    }
  }
}
