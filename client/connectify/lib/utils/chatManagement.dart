import 'dart:convert';

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

  static Future<Chat> createChat(String name, String phone) async {
    Chat newChat = Chat(name, phone, "", 0, "");
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
      String sender, String receiver) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return await Messageprovider.getMessagesOfChat(db!, sender, receiver);
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
      'hasattachment': 0
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
}
