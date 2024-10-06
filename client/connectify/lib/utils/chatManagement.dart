import 'dart:convert';
import 'dart:io';

import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/messageProvider.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:Connectify/requests/chats_api.dart';
import 'package:Connectify/requests/webSocketService.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ChatManagement {
  static ValueNotifier<List<Message>>? messages = null;
  static ValueNotifier<List<Chat>>? chats = null;

  static Future<dynamic> loadSender() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return await UserProvider.getLoggedUser(db!);
  }
  static Future<String?> encodeFile(File file) async {
    try{
      List<int> bytes = await file.readAsBytes();
      String base64 = base64Encode(bytes);
      return base64;
    }catch(e){
      return null;
    }
  }

  static Future<Chat> createChat(String name, String phone) async {
    String time = DateTime.now().toIso8601String();
    Chat newChat = Chat(name, phone, "", 0, time);
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Chat? createdChat = await Chatprovider.getChatByPhone(phone, db!);
    if (createdChat == null) {
      Chatprovider.insert(newChat, db);
    } else {
      newChat = createdChat;
    }
    return newChat;
  }

  static Future<List<Message>> queryMessages(
      String sender, String receiver, int offset) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    List<Message> queried_messages =
        await Messageprovider.getMessagesOfChat(db!, sender, receiver, offset);
    return List.from(queried_messages.reversed);
  }

  static socketHandler(String message) {
    print(message);
    Map p = jsonDecode(message);
    if (p['signal'] == 0) {
      handleMessage(p);
    } else {
      if (p.containsKey('command_type')) {
        handleLogoutSignal();
      } else {
        handleSeen(p);
      }
    }
  }

  static void handleSeen(Map m) {}

  static void handleMessage(Map p) async {
    Message m = Message(
        p['message_id'], p['sender'], p['receiver'], p['time'], p['text']);
    if (p.containsKey('replied') && p['replied'] != 'none') {
      m.replied = p['replied'];
    }
    if (p.containsKey('attachment')){
      m.attachment = p['attachment'];
    }
    
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Messageprovider.insert(m, db!);
    if (messages != null) {
      messages!.value = List.from(messages!.value)..add(m);
    }
    await updateChat(m.sender!, m, db);
    print(m);
  }

  static void handleLogoutSignal() {}
  static void sendMessage(Message m) async {
    Map dict = {
      'signal': 0,
      'message_id': m.id,
      'sender': m.sender,
      'receiver': m.receiver,
      'time': m.time,
      'text': m.stringContent,
      'attachment': m.attachment
    };
    if (m.replied != null) {
      dict['replied'] = m.replied;
    }
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Messageprovider.insert(m, db!);
    String content = jsonEncode(dict);
    WebSocketService().sendMessage(content);
    await updateChat(m.receiver!, m, db);
  }

  static Future<void> updateChat(String contact, Message m, Database db) async {
    Chat? chat = await Chatprovider.getChatByPhone(contact, db);
    if (chat == null) {
      chat = Chat("", contact, m.stringContent, 0, m.time);
      await Chatprovider.insert(chat, db);
      chats!.value = List.from(chats!.value)..insert(0, chat);
    } else {
      chat.last = m.stringContent;
      chat.time = m.time;
      await Chatprovider.update(chat, db);
      for (int i = 0; i < chats!.value.length; i++) {
        if (chat.contact == chats!.value[i].contact) {
          chats!.value = List.from(chats!.value)
            ..removeAt(i)
            ..insert(0, chat);
          break;
        }
      }
    }
  }

  static Future<Map> get_Profiles(List<String> numbers) async {
    ChatsAPI chatsAPI = ChatsAPI();
    return chatsAPI.getProfiles(numbers);
  }

  static Future<void> update_starred(Message message) async {
    message.starred = message.starred == 0 || message.starred == null ? 1 : 0;
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Messageprovider.update(message, db!);
  }

  static Future<List<Message>> getStarred() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return Messageprovider.getStarredMessages(db!);
  }

  static Future<String?> getName(String phone) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Chat? chat = await Chatprovider.getChatByPhone(phone, db!);
    return chat?.contact;
  }

  static Future<List<Message>> getSearched(String searchString) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return Messageprovider.getMessagesContaining(searchString, db!);
  }
}
