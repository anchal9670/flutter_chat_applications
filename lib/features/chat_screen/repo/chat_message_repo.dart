import 'package:chat_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class MessageRepo {
  final API _api;
  final Ref _ref;

  MessageRepo({required API api, required Ref ref})
      : _api = api,
        _ref = ref;

  FutureEither<Response> getMessage() async {
    final result = await _api.getRequest(
      url:
          "http://192.168.1.12:5000/messages?senderDocId=678f7024f8389c9944f10fc8&receiverDocId=678f56b6502552cb931e6c7f",
    );
    return result;
  }
}

final messageRepoProvider = Provider<MessageRepo>((ref) {
  final api = ref.watch(apiProvider);
  return MessageRepo(api: api, ref: ref);
});
