import 'dart:convert';
import 'dart:io';

import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/core/user.dart';
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
  static String? curr_contact = null;
  static ValueNotifier<List<Chat>>? chats = null;
  static VoidCallback refreshHome = () {};

  static Future<dynamic> loadSender() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return await UserProvider.getLoggedUser(db!);
  }


  static Future<String?> encodeFile(File file) async {
    try {
      List<int> bytes = await file.readAsBytes();
      String base64 = base64Encode(bytes);
      return base64;
    } catch (e) {
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
    } else if (p['signal'] == 1) {
      handleLogoutSignal();
    } else if (p['signal'] == 2) {
      receiveMessageArrival(p);
    } else if (p['signal'] == 3) {
      receiveMessageSeen(p);
    }
  }

  static void handleSeen(Map m) {}

  static void handleMessage(Map p) async {
    Message m = Message(
        p['message_id'], p['sender'], p['receiver'], p['time'], p['text'], 1);
    if (p.containsKey('replied') && p['replied'] != 'none') {
      m.replied = p['replied'];
    }
    if (p.containsKey('attachment'))  {
      m.attachment = p['attachment'];
    }


    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Messageprovider.insert(m, db!);
    if (messages != null && curr_contact == m.sender) {
      messages!.value = List.from(messages!.value)..add(m);
    }
    await updateChat(m.sender!, m, db);
    // Send acknowledgment of arrival after storing the message
    if (curr_contact != m.sender)
      await ChatManagement.acknowledgeMessageArrival(m);
    refreshHome();

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
      'attachment': m.attachment,
      'is_seen_level': 1
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

  static Future<void> deleteChat(Chat chat) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    User? user = await UserProvider.getLoggedUser(db!);
    Chatprovider.delete(chat.id!, db);
    Messageprovider.DeleteMessages(db, user!.phone!, chat.phone!);
  }

  static Future<void> update_favourite(Chat chat) async {
    chat.favourite = chat.favourite == 1 ? 0 : 1;
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    Chatprovider.update(chat, db!);
  }

  static Future<List<Chat>> getFavourite() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    return Chatprovider.getFavouriteContacts(db!);
  }


  static Future<void> acknowledgeMessageArrival(Message message) async {
    Map<String, dynamic> acknowledgment = {
      'signal': 2, // 2 is the signal for arrival acknowledgment
      'message_id': message.id,
      'sender': message.receiver, // The current user who received the message
      'receiver': message.sender,
      'time': DateTime.now().toIso8601String(),
    };

    String content = jsonEncode(acknowledgment);
    WebSocketService().sendMessage(content);
    print('Sent arrival acknowledgment for message: ${message.id}');
  }

  static Future<void> acknowledgeMessageSeen(Message message) async {
    // Update the message's isSeenLevel to 2 (seen)
    message.isSeenLevel = 2;

    Map<String, dynamic> acknowledgment = {
      'signal': 3, // 3 is the signal for seen acknowledgment
      'message_id': message.id,
      'sender': message.receiver,
      'receiver': message.sender,
      'time': DateTime.now().toIso8601String(),
    };

    String content = jsonEncode(acknowledgment);
    WebSocketService().sendMessage(content);
    print('Sent seen acknowledgment for message: ${message.id}');

    // Update the database with the new isSeenLevel
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    await Messageprovider.update(message, db!);

    // Update the messages list if necessary (UI update)
    if (messages != null) {
      int index = messages!.value.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages!.value[index] = message;
      }
    }

    print('Message marked as seen and database updated: ${message.id}');
  }

  static Future<void> receiveMessageArrival(Map<dynamic, dynamic> data) async {
    print('Received message arrival: $data');
    String messageId = data['message_id'];
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;

    Message? message = await Messageprovider.getMessage(messageId, db!);

    if (message != null) {
      if (message.isSeenLevel != 2) message.isSeenLevel = 1; // Mark as arrived
      await Messageprovider.update(message, db);

      if (messages != null) {
        int index = messages!.value.indexWhere((m) => m.id == messageId);
        // Update UI if inside the chat
        if (index != -1) {
          messages!.value[index] = message;
          messages!.value = List.from(messages!.value);
        }
      }

      print('Updated arrival status for message: $messageId');
    } else {
      print('Message not found: $messageId');
    }
  }

  static Future<void> receiveMessageSeen(Map<dynamic, dynamic> data) async {
    print('Received message seen: $data');
    String messageId = data['message_id'];

    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;

    Message? message = await Messageprovider.getMessage(messageId, db!);

    if (message != null) {
      message.isSeenLevel = 2; // Mark as seen
      await Messageprovider.update(message, db);

      if (messages != null) {
        int index = messages!.value.indexWhere((m) => m.id == messageId);
        // Update UI if inside the chat
        if (index != -1) {
          messages!.value[index] = message;
          messages!.value = List.from(messages!.value);
        }
      }

      print('Updated seen status for message: $messageId');
    } else {
      print('Message not found: $messageId');
    }
  }

  static Future<void> acknowledgeIfNeeded(Message message) async {
    if (message.isSeenLevel != 2) {
      await acknowledgeMessageSeen(message);
    }
  }
}
