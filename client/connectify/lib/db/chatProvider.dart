
import 'package:Connectify/core/chat.dart';
import 'package:sqflite/sqflite.dart';

class Chatprovider {
  static Future<dynamic> insert(Chat chat, Database db) async{
    await db.insert(tableChat, chat.toMap());
  }
  static Future<List<Chat>> getAllChats(Database db) async{
    List<Map<String, dynamic>> maps = await db.query(tableChat,
    columns: [columnId, columnContact, columnPhone, columnLastMessage, columnAlert,columnTime],
    ) as List<Map<String, dynamic>>;
    List<Chat> res = [];
    for (Map<String, dynamic> map in maps){
      res.add(Chat.fromMap(map));
    }
    return res;
  }
  static Future<Chat?> getChat(int id, Database db) async{
    List<Map<String, dynamic>> maps = await db.query(tableChat, 
    columns:[columnId, columnContact, columnPhone, columnLastMessage, columnAlert,columnTime],
    where: '$columnId = ?',
    whereArgs: [id]
    ) as List<Map<String,dynamic>>;
    if (maps.length > 0){
      return Chat.fromMap(maps.first);
    }
    return null;
  } 
  static Future<Chat?> getChatByPhone(String phone, Database db) async{
    List<Map<String, dynamic>> maps = await db.query(tableChat, 
    columns:[columnId, columnContact, columnPhone, columnLastMessage, columnAlert,columnTime],
    where: '$columnPhone = ?',
    whereArgs: [phone]
    ) as List<Map<String,dynamic>>;
    if (maps.length > 0){
      return Chat.fromMap(maps.first);
    }
    return null;
  } 
  static Future<void> clearTable(Database db ) async{
    await db.delete(tableChat, where: null);
  }

  static Future<int> update(Chat chat, Database db) async{
    return await db.update(tableChat, chat.toMap(),
    where: '$columnId = ?', whereArgs: [chat.id]);
  }

  static delete(int id, Database db) async{
    return await db.delete(tableChat, where: '$columnId = ?', whereArgs: [id]);
  }

  
}