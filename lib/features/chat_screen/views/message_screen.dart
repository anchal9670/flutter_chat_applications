import 'package:chat_app/features/chat_screen/controller/chat_message_controller.dart';
import 'package:chat_app/features/home/controller/list_message_controller.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MessageListView extends ConsumerStatefulWidget {
  final String sender;
  final String receiver;
  const MessageListView(
      {required this.sender, required this.receiver, super.key});

  @override
  ConsumerState<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends ConsumerState<MessageListView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SocketService _socketService = SocketService(); // ✅ Singleton

  @override
  void initState() {
    super.initState();

    // if (!_socketService.isConnected) {
    //   _socketService.connect(widget.sender);
    // }
    if (!_socketService.isConnected) {
      _socketService.connect(widget.sender, (updatedChatList) {
        ref
            .read(listOfMessageControllerProvider.notifier)
            .updateMessages(updatedChatList);
      });
    }

    _socketService.socket.onConnect((_) {
      setState(() {}); // ✅ Rebuild UI when connected
    });

    _socketService.socket.onDisconnect((_) {
      setState(() {}); // ✅ Rebuild UI when disconnected
    });

    _socketService.onMessageReceived((data) {
      if (mounted) {
        ref.read(messageControllerProvider.notifier).addMessage(data);
        _scrollToBottom();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageControllerProvider.notifier).getMessage(
          senderDocId: widget.sender, receiverDocId: widget.receiver);
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = Message(
        senderDocId: widget.sender,
        receiverDocId: widget.receiver,
        message: _controller.text,
      );

      _socketService.sendMessage(
          widget.sender, widget.receiver, _controller.text);

      ref.read(messageControllerProvider.notifier).addMessage(message);

      _controller.clear();
      _scrollToBottom();
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return ''; // Handle null timestamps
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat.jm().format(dateTime); // Converts to 12-hour format
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_socketService.isConnected ? 'Connected' : 'Disconnected'),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('No messages found'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final bool isMe = message.senderDocId == widget.sender;

                      // Parse the message date
                      DateTime messageDate = DateTime.parse(
                        message.createdAt.toString(),
                      );
                      DateTime now = DateTime.now();
                      DateTime yesterday = now.subtract(Duration(days: 1));

                      // Determine date header text
                      String formattedDate;
                      if (DateFormat('yyyy-MM-dd').format(messageDate) ==
                          DateFormat('yyyy-MM-dd').format(now)) {
                        formattedDate = "Today";
                      } else if (DateFormat('yyyy-MM-dd').format(messageDate) ==
                          DateFormat('yyyy-MM-dd').format(yesterday)) {
                        formattedDate = "Yesterday";
                      } else {
                        formattedDate =
                            DateFormat('dd-MM-yyyy').format(messageDate);
                      }

                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        DateTime prevMessageDate = DateTime.parse(
                            messages[index - 1].createdAt.toString());
                        if (DateFormat('yyyy-MM-dd').format(messageDate) !=
                            DateFormat('yyyy-MM-dd').format(prevMessageDate)) {
                          showDateHeader = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: isMe
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  bottomRight: isMe
                                      ? Radius.circular(0)
                                      : Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.message ?? '',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(messageDate), // ✅ Show Time
                                        style: TextStyle(
                                          color: isMe
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                      if (isMe) SizedBox(width: 4),
                                      if (isMe)
                                        Icon(
                                          Icons.done_all,
                                          size: 14,
                                          color: Colors.white70,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
