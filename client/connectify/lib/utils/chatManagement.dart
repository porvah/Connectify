import 'dart:convert';

import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/messageProvider.dart';
import 'package:Connectify/requests/webSocketService.dart';
import 'package:sqflite/sqflite.dart';

class ChatManagement {
  static Future<Chat> createChat(String name, String phone)async{
    Chat newChat = Chat(name, phone, "", 0);
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Chat? createdChat = await Chatprovider.getChatByPhone(phone, db!);
    if( createdChat == null){
      Chatprovider.insert(newChat, db);
    }else{
      newChat = createdChat;
    }
    return newChat;
    
  }
  // static void navigateChat(BuildContext ctx, Chat chat){
  //   Navigator.of(ctx).pushNamed()
  // }


  static void socketHandler(String message){
    print(message);
    Map p = jsonDecode(message);
    if (p['signal'] == 0){
      handleMessage(p);
    }else{
      if(p.containsKey('command_type')){
        handleLogoutSignal();
      }else{
        handleSeen(p);
      }
    }
  }
  static void handleSeen(Map m){

  }

  static void handleMessage(Map p)async{
    Message m = Message(p['message_id'], p['sender'], p['receiver'],
     p['time'], p['text']);
    if(p.containsKey('replied') && p['replied'] != 'none'){
      m.replied = p['replied'];
    }
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Messageprovider.insert(m, db!);
    print(m);
  }
  static void handleLogoutSignal(){

  }
  static void sendMessage(Message m){
    Map dict = {
      'signal' : 0,
      'message_id': m.id,
      'sender': m.sender,
      'receiver': m.receiver,
      'time': m.time,
      'text': m.stringContent,
      'hasattachment': 0
    };
    if( m.replied != null){
      dict['replied'] = m.replied;
    }

    String content = jsonEncode(dict);
    WebSocketService().sendMessage(content);
  }
}