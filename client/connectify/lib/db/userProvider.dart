import 'package:Connectify/core/user.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider{
  static Future<dynamic> insert(User user, Database db) async{
    user.id = await db.insert(tableUser, user.toMap());
  }
  
  static Future<User?> getUser(String phone, Database db) async{
    List<Map<String,Object>> maps = await db.query(tableUser, 
    columns:[columnId, columnEmail, columnPhone, columnLogged],
    where: '$columnPhone = ?',
    whereArgs: [phone]
    ) as List<Map<String,Object>>;
    if (maps.length > 0){
      return User.fromMap(maps.first);
    }
    return null;
  } 

  static Future<int> update(User user, Database db) async{
    return await db.update(tableUser, user.toMap(),
    where: '$columnId = ?', whereArgs: [user.id]);
  }

  static delete(int id, Database db) async{
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<User?> getLoggedUser(Database db)async{
    List<Map<String,Object>> maps = await db.query(tableUser, 
    columns:[columnId, columnEmail, columnPhone, columnLogged],
    where: '$columnLogged = ?',
    whereArgs: [1]
    ) as List<Map<String,Object>>;
    if (maps.length > 0){
      return User.fromMap(maps.first);
    }
    return null;
  }

}