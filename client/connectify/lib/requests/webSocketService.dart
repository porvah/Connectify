import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class WebSocketService {
  WebSocketChannel? _channel;
  final _url = dotenv.env['WS_URL'];
  // Singleton pattern
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();
  final int _reconnectDelay = 5; 
  bool _isReconnecting = false;

  Future<void> connect() async {
    if (_channel == null) {
      Database? db = await Dbsingleton().db;
      User? user = await UserProvider.getLoggedUser(db!);
      Uri uri =Uri.parse(_url!+user!.token!+'/');
      print(uri);
      _channel = WebSocketChannel.connect(uri);
      _channel?.stream.listen((message) {
        print("..");
        ChatManagement.socketHandler(message);
      }, onError: (error) {
        print("WebSocket error: $error");
        _reconnect(); 
      }, onDone: () {
        print("WebSocket closed");
        _channel = null; 
        _reconnect();
      });
    }
  }

  // Send a message (optional)
  void sendMessage(String message) {
    if (_channel != null) {
      _channel?.sink.add(message);
    }
  }
  void _reconnect() {
    if (!_isReconnecting) {
      _isReconnecting = true;
      Future.delayed(Duration(seconds: _reconnectDelay), () async {
        print("Attempting to reconnect...");
        await connect();
        _isReconnecting = false; 
      });
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
