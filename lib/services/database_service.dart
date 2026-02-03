import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const int _databaseVersion = 1;
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      inMemoryDatabasePath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees (
            id TEXT PRIMARY KEY,
            fullName TEXT NOT NULL,
            jobTitle TEXT NOT NULL,
            country TEXT NOT NULL,
            salary INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

