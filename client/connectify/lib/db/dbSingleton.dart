import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbsingleton {
  static final Dbsingleton _instance = Dbsingleton._internal();
  static Database? _db;

  // Private constructor
  Dbsingleton._internal();

  // Factory constructor to return the same instance
  factory Dbsingleton() {
    return _instance;
  }

  // Getter for the database instance
  Future<Database?> get db async {
    if (_db != null) return _db; // Return existing instance
    _db = await open(); // Initialize if not already done
    return _db;
  }

  // Open the database
  Future<Database> open() async {
    try {
      String dbPath = await getDatabasesPath(); // Get database path
      String path = join(dbPath, 'connectify.db'); // Join the path
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: _setupTables, // Set up tables on creation
      );
    } catch (e) {
      print("Error opening database: $e"); // Catch and log errors
    }
    return _db!; // Ensure to return a non-null database
  }

  // Setup the tables in the database
  Future<void> _setupTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        logged INTEGER NOT NULL,
        token TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE message (
        id TEXT NOT NULL,
        sender TEXT NOT NULL,
        receiver TEXT NOT NULL,
        replied_id TEXT,
        time TEXT NOT NULL,
        string_content TEXT NOT NULL,
        attachment TEXT,
        starred INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE chat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        last TEXT,
        alert INTEGER NOT NULL,
        time TEXT,
        favourite INTEGER DEFAULT 0
      )
  ''');
  }

  // Close the database
  Future<void> close() async {
    await _db?.close(); // Close the database if it's not null
    _db = null; // Reset the database instance to allow reinitialization
  }
}
