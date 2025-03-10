import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool _isConnected = false;

  void connect(String userId) {
    if (_isConnected) return;

    socket = IO.io('http://192.168.1.12:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
    });

    socket.onConnect((_) {
      print('✅ Connected to Socket.IO Server');
      _isConnected = true;
      joinChat(userId);
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO Server');
      _isConnected = false;
    });

    socket.onReconnect((_) {
      print('🔄 Reconnected to Socket.IO Server');
      _isConnected = true;
    });

    socket.onReconnectAttempt((_) => print('🔄 Trying to reconnect...'));
    socket.onReconnectError((error) => print('⚠️ Reconnection Error: $error'));
    socket.onConnectError((error) => print('⚠️ Connection Error: $error'));
    socket.onError((error) => print('🚨 Socket Error: $error'));

    socket.connect();
  }

  void joinChat(String userId) {
    socket.emit('join_chat', userId);
  }

  void sendMessage(String sender, String receiver, String message) {
    if (!_isConnected) {
      print("❌ Cannot send message: Not connected");
      return;
    }
    socket.emit('send_message', {
      'senderDocId': sender,
      'receiverDocId': receiver,
      'message': message,
    });
  }

  void onMessageReceived(Function(dynamic) callback) {
    socket.on('receive_message', callback);
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      _isConnected = false;
    }
  }
}
