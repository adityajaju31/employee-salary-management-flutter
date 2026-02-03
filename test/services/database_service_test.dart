import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:employee_salary_app/services/database_service.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseService', () {
    test('should open database successfully', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      expect(database, isNotNull);
      expect(database.isOpen, true);
      
      await service.close();
    });

    test('should create employees table with correct columns', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      final tableInfo = await database.rawQuery(
        "PRAGMA table_info(employees)",
      );
      
      expect(tableInfo, isNotEmpty);
      
      final columnNames = tableInfo
          .map((row) => row['name'] as String)
          .toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('fullName'));
      expect(columnNames, contains('jobTitle'));
      expect(columnNames, contains('country'));
      expect(columnNames, contains('salary'));
      
      await service.close();
    });

    test('should have id as primary key', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      final tableInfo = await database.rawQuery(
        "PRAGMA table_info(employees)",
      );
      
      final idColumn = tableInfo.firstWhere(
        (row) => row['name'] == 'id',
      );
      
      expect(idColumn['pk'], 1);
      
      await service.close();
    });

    test('should have correct column types', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      final tableInfo = await database.rawQuery(
        "PRAGMA table_info(employees)",
      );
      
      final columns = {
        for (var row in tableInfo)
          row['name'] as String: row['type'] as String
      };
      
      expect(columns['id'], contains('TEXT'));
      expect(columns['fullName'], contains('TEXT'));
      expect(columns['jobTitle'], contains('TEXT'));
      expect(columns['country'], contains('TEXT'));
      expect(columns['salary'], contains('INTEGER'));
      
      await service.close();
    });

    test('should handle database versioning correctly', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      final version = await database.getVersion();
      
      expect(version, greaterThan(0));
      
      await service.close();
    });

    test('should return same database instance on multiple calls', () async {
      final service = DatabaseService();
      final database1 = await service.database;
      final database2 = await service.database;
      
      expect(database1, same(database2));
      
      await service.close();
    });

    test('should close database successfully', () async {
      final service = DatabaseService();
      final database = await service.database;
      
      expect(database.isOpen, true);
      
      await service.close();
      
      expect(database.isOpen, false);
    });
  });
}

