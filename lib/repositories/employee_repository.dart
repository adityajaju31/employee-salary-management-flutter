import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class EmployeeRepository {
  final DatabaseService _databaseService;

  EmployeeRepository(this._databaseService);

  Future<void> insertEmployee(Employee employee) async {
    final db = await _databaseService.database;
    await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await _databaseService.database;
    final maps = await db.query('employees');
    return maps.map((map) => Employee.fromMap(map)).toList();
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await _databaseService.database;
    await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

