import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static const int _databaseVersion = 1;
  Database? _database;
  final String? _databasePath;

  DatabaseService({String? databasePath}) : _databasePath = databasePath;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final path = _databasePath ?? await _getPersistentPath();

    _database = await openDatabase(
      path,
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

  Future<String> _getPersistentPath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, 'employees.db');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

