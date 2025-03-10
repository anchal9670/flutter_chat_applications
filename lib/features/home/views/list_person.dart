import 'package:chat_app/features/chat_screen/views/message_screen.dart';
import 'package:chat_app/features/home/controller/list_message_controller.dart';
import 'package:chat_app/features/chat_screen/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOfChatsViews extends ConsumerStatefulWidget {
  const ListOfChatsViews({super.key});

  @override
  ConsumerState<ListOfChatsViews> createState() => _ListOfChatsViewsState();
}

class _ListOfChatsViewsState extends ConsumerState<ListOfChatsViews> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await ref.read(listOfMessageControllerProvider.notifier).getListOfMessage();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(listOfMessageControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Chats'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  minVerticalPadding: 15,
                  leading: Image.network(chatList[index].secondPersonAvatar!),
                  title: Text(chatList[index].secondPersonName!),
                  subtitle: Text(chatList[index].lastMessage!),
                  tileColor: Colors.grey[200],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageListView(
                          sender: '678f7024f8389c9944f10fc8',
                          receiver: '678f56b6502552cb931e6c7f',
                        ),
                      ),
                    );
                  },
                );
              }),
    );
  }
}
