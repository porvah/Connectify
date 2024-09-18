import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbsingleton{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null) return _db;
    _db = await open();
    return _db;
  }

  Future open() async{
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'connectify.db');
    _db = await openDatabase(path, version: 1,
      onCreate: _setupTables);
      }

  _setupTables(Database db, int version) async{
    await db.execute('''
CREATE TABLE user (
  id integer primary key autoincrement,
  email text not null,
  phone text not null unique,
  logged integer not null)
      ''');
    
  }
  Future close() async => _db?.close();
    
}