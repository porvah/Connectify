import 'dart:convert';

import 'package:Connectify/core/message.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/messageProvider.dart';
import 'package:Connectify/requests/webSocketService.dart';
import 'package:sqflite/sqflite.dart';

class ChatManagement {
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
    sendMessage(m);
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