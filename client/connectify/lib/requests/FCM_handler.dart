import 'dart:convert';

import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

final _url = dotenv.env['API_URL'];

class NotificationService{
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  
  static Future<void> _backgroundHandler(RemoteMessage message)async {
    print(message.data);
  }

  static Future<void> _foregroundHandler(RemoteMessage message)async{
    print(message.data);
  }
  static Future<void> initialize()async{
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_foregroundHandler);
  }
  static Future<void> getToken() async{
    await _firebaseMessaging.requestPermission();
    String? device_token = await _firebaseMessaging.getToken();
    print("FCM token = $device_token");
    try {
      Dbsingleton dbsingleton = Dbsingleton();
      Database? db = await dbsingleton.db;
      User? logged = await UserProvider.getLoggedUser(db!);
      final response = await http.post(
        Uri.parse(_url! + 'chat/sendtoken/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'userPhone': logged!.phone!,
          'fcm_token': device_token!,
        }),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
      } else {
        print('Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('FCM token post failed! Error: $e');
    }
  }
}