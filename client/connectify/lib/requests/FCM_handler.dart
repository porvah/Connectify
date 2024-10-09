import 'dart:convert';

import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final _url = dotenv.env['API_URL'];

class NotificationService{
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  static Future<void> _backgroundHandler(RemoteMessage message)async {
    await _showNotification(message);

    print(message.data);
  }

  static Future<void> _foregroundHandler(RemoteMessage message)async{
    String? opened_chat = ChatManagement.curr_contact;
    if(opened_chat == null || opened_chat != message.data['sender']){
      await _showNotification(message);
    }
    print(message.data);
  }
  static Future<void> _showNotification(RemoteMessage message) async{
    final data = message.data;
    String? sender = data['sender'];
    String? body = data['text'];
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Chat? senderChat = await Chatprovider.getChatByPhone(sender!, db!);
    if(senderChat != null){
      sender = (senderChat.contact == "")? sender : senderChat.contact;
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
      'high_importance_channel', // channel ID
      'High Importance Notifications', // channel name
      channelDescription: 'This channel is used for important notifications.', // channel description
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.show(
      0,
      sender,
      body,
      platformChannelSpecifics
    );
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
  static void createNotificationChannel() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}