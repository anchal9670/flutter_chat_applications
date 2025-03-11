import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/features/chat_screen/repo/chat_message_repo.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageController extends StateNotifier<List<Message>> {
  final MessageRepo _repo;

  MessageController(this._repo) : super([]);

  Future<void> getMessage(
      {required String senderDocId, required String receiverDocId}) async {
    try {
      final result = await _repo.getMessage(
          senderDocId: senderDocId, receiverDocId: receiverDocId);
      result.fold(
        (failure) {
          log('Failure: $failure');
        },
        (response) {
          final data = jsonDecode(response.body);
          final messageList = data['data'] as List;
          final messages =
              messageList.map((message) => Message.fromJson(message)).toList();
          state = messages;
        },
      );
    } catch (e, stacktrace) {
      log('Error: $e');
      log('Stacktrace: $stacktrace');
    }
  }

  void addMessage(dynamic data) {
    final message = Message(
      senderDocId: data['senderDocId'],
      receiverDocId: data['receiverDocId'],
      message: data['message'],
      createdAt: DateTime.now(),
    );
    state = [...state, message];
  }
}

// Provider for controller
final messageControllerProvider =
    StateNotifierProvider<MessageController, List<Message>>((ref) {
  final repository = ref.watch(messageRepoProvider);
  return MessageController(repository);
});
