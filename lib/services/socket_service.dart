// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   late IO.Socket socket;
//   bool _isConnected = false;

//   void connect(String userId) {
//     if (_isConnected) return;

//     socket = IO.io('http://192.168.1.12:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'reconnection': true,
//       'reconnectionAttempts': 5,
//       'reconnectionDelay': 2000,
//     });

//     socket.onConnect((_) {
//       print('✅ Connected to Socket.IO Server');
//       _isConnected = true;
//       joinChat(userId);
//     });

//     socket.onDisconnect((_) {
//       print('❌ Disconnected from Socket.IO Server');
//       _isConnected = false;
//     });

//     socket.onReconnect((_) {
//       print('🔄 Reconnected to Socket.IO Server');
//       _isConnected = true;
//     });

//     socket.onReconnectAttempt((_) => print('🔄 Trying to reconnect...'));
//     socket.onReconnectError((error) => print('⚠️ Reconnection Error: $error'));
//     socket.onConnectError((error) => print('⚠️ Connection Error: $error'));
//     socket.onError((error) => print('🚨 Socket Error: $error'));

//     socket.connect();
//   }

//   void joinChat(String userId) {
//     socket.emit('join_chat', userId);
//   }

//   void sendMessage(String sender, String receiver, String message) {
//     if (!_isConnected) {
//       print("❌ Cannot send message: Not connected");
//       return;
//     }
//     socket.emit('send_message', {
//       'senderDocId': sender,
//       'receiverDocId': receiver,
//       'message': message,
//     });
//   }

//   void onMessageReceived(Function(dynamic) callback) {
//     socket.on('receive_message', callback);
//   }

//   void disconnect() {
//     if (_isConnected) {
//       socket.disconnect();
//       _isConnected = false;
//     }
//   }
// }

import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();

//   late IO.Socket socket;
//   bool _isConnected = false;

//   bool get isConnected => _isConnected; // ✅ Add this getter

//   void connect(String userId) {
//     if (_isConnected) return; // Prevent multiple connections

//     socket = IO.io('http://192.168.1.12:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'reconnection': true,
//       'reconnectionAttempts': 5,
//       'reconnectionDelay': 2000,
//     });

//     socket.onConnect((_) {
//       print('✅ Connected to Socket.IO Server');
//       _isConnected = true;
//       joinChat(userId);
//     });

//     socket.onDisconnect((_) {
//       print('❌ Disconnected from Socket.IO Server');
//       _isConnected = false;
//     });

//     socket.connect();
//   }

//   void joinChat(String userId) {
//     socket.emit('join_chat', userId);
//   }

//   void sendMessage(String sender, String receiver, String message) {
//     if (!_isConnected) {
//       print("❌ Cannot send message: Not connected");
//       return;
//     }
//     socket.emit('send_message', {
//       'senderDocId': sender,
//       'receiverDocId': receiver,
//       'message': message,
//     });
//   }

//   void onMessageReceived(Function(dynamic) callback) {
//     socket.on('receive_message', callback);
//   }

//   void disconnect() {
//     socket.disconnect();
//     _isConnected = false;
//   }
// }

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(String userId, Function(List<dynamic>) onGetAllMessages) {
    if (_isConnected) return; // Prevent multiple connections

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

    // ✅ Listen for updated chat list
    socket.on('get_list_message', (data) {
      print('📩 Received updated chat list: $data');
      onGetAllMessages(data);
    });

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
    socket.disconnect();
    _isConnected = false;
  }
}
