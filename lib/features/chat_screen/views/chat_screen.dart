import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';
import '../../../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String sender;
  final String receiver;

  const ChatScreen({super.key, required this.sender, required this.receiver});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final SocketService _socketService = SocketService();
  final ScrollController _scrollController = ScrollController();
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _socketService.connect(widget.sender);
    _socketService.socket.onConnect((_) {
      setState(() => _isConnected = true);
    });
    _socketService.socket.onDisconnect((_) {
      setState(() => _isConnected = false);
    });
    _socketService.onMessageReceived((data) {
      setState(() {
        _messages.add(data);
      });
      _scrollToBottom();
    });
    _fetchMessages();
  }

  void _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.9:5000/messages?senderDocId=${widget.sender}&receiverDocId=${widget.receiver}'));

      if (response.statusCode == 200) {
        setState(() {
          _messages.addAll(
            List<Map<String, dynamic>>.from(
              json.decode(response.body),
            ),
          );
        });
      }
    } catch (e) {
      print('Failed to fetch messages: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'sender': widget.sender,
        'receiver': widget.receiver,
        'message': _controller.text,
      };
      _socketService.sendMessage(
          widget.sender, widget.receiver, _controller.text);
      setState(() {
        _messages.add(message);
        _controller.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isConnected
              ? 'Chat with ${widget.receiver}'
              : 'Disconnected - Chat with ${widget.receiver}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Text(
                          message['message'],
                          style: TextStyle(
                            color: message['sender'] == widget.sender
                                ? Colors.blue
                                : Colors.green,
                          ),
                        ),
                        subtitle: Text('From: ${message['sender']}'),
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
                    decoration: InputDecoration(hintText: 'Type a message'),
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
