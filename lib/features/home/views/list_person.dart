import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/home/controller/list_message_controller.dart';
import 'package:chat_app/features/chat_screen/views/message_screen.dart';
import 'package:chat_app/services/socket_service.dart';

class ListOfChatsViews extends ConsumerStatefulWidget {
  final String userId;
  const ListOfChatsViews({super.key, required this.userId});

  @override
  ConsumerState<ListOfChatsViews> createState() => _ListOfChatsViewsState();
}

class _ListOfChatsViewsState extends ConsumerState<ListOfChatsViews> {
  bool isLoading = true;
  final SocketService socketService = SocketService(); // ✅ Singleton

  @override
  void initState() {
    super.initState();

    // if (!socketService.isConnected) {
    //   socketService.connect(widget.userId);
    // }
    if (!socketService.isConnected) {
      socketService.connect(widget.userId, (updatedChatList) {
        ref
            .read(listOfMessageControllerProvider.notifier)
            .updateMessages(updatedChatList);
      });
    }

    _fetchData();

    // ✅ Listen for incoming messages
    socketService.socket.on("receive_message", (data) {
      _fetchData(); // Refresh chat list
    });

    // ✅ Listen for updated chat list
    socketService.socket.on("get_list_message", (data) {
      _fetchData();
    });
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
      appBar: AppBar(title: const Text('List of Chats')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    minVerticalPadding: 15,
                    leading: Image.network(chatList[index].secondPersonAvatar!),
                    title: Text(chatList[index].secondPersonName!),
                    subtitle: Text(chatList[index].lastMessage!),
                    trailing: chatList[index].unreadCount != null &&
                            chatList[index].unreadCount! > 0
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, color: Colors.red, size: 24),
                              Text(
                                chatList[index].unreadCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    tileColor: Colors.grey[200],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageListView(
                            sender: "678f7024f8389c9944f10fc8",
                            receiver: chatList[index].secondPersonId!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
    );
  }
}
