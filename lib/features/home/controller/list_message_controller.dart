import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/features/home/repo/list_message_repo.dart';
import 'package:chat_app/models/list_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listOfMessageControllerProvider =
    StateNotifierProvider<ListMessageController, List<ListOfMessage>>((ref) {
  final complaintRepo = ref.read(listMessageRepoProvider);
  return ListMessageController(
      complaint: ListOfMessage(), repo: complaintRepo, ref: ref);
});

class ListMessageController extends StateNotifier<List<ListOfMessage>> {
  final ListMessageRepo _repo;
  final Ref _ref;

  ListMessageController({
    required ListOfMessage complaint,
    required ListMessageRepo repo,
    required Ref ref,
  })  : _ref = ref,
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

  void updateMessages(List<dynamic> newMessages) {
    final updatedMessages =
        newMessages.map((message) => ListOfMessage.fromJson(message)).toList();
    state = updatedMessages;
  }
}
