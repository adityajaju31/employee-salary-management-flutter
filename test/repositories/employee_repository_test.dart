import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:employee_salary_app/models/employee.dart';
import 'package:employee_salary_app/repositories/employee_repository.dart';
import 'package:employee_salary_app/services/database_service.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('EmployeeRepository', () {
    late DatabaseService databaseService;
    late EmployeeRepository repository;

    setUp(() async {
      databaseService = DatabaseService(databasePath: inMemoryDatabasePath);
      repository = EmployeeRepository(databaseService);
    });

    tearDown(() async {
      await databaseService.close();
    });

    test('should insert an employee into database', () async {
      final employee = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );

      await repository.insertEmployee(employee);

      final employees = await repository.getAllEmployees();
      expect(employees.length, 1);
      expect(employees.first.id, '1');
      expect(employees.first.fullName, 'John Doe');
    });

    test('should fetch all employees from database', () async {
      final employee1 = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );
      final employee2 = Employee(
        id: '2',
        fullName: 'Jane Smith',
        jobTitle: 'Product Manager',
        country: 'Canada',
        salary: 110000,
      );

      await repository.insertEmployee(employee1);
      await repository.insertEmployee(employee2);

      final employees = await repository.getAllEmployees();
      expect(employees.length, 2);
      expect(employees.map((e) => e.id).toList(), containsAll(['1', '2']));
    });

    test('should update an existing employee', () async {
      final employee = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );

      await repository.insertEmployee(employee);

      final updatedEmployee = employee.copyWith(
        fullName: 'John Smith',
        salary: 100000,
      );

      await repository.updateEmployee(updatedEmployee);

      final employees = await repository.getAllEmployees();
      expect(employees.length, 1);
      expect(employees.first.fullName, 'John Smith');
      expect(employees.first.salary, 100000);
      expect(employees.first.jobTitle, 'Software Engineer');
    });

    test('should delete an employee from database', () async {
      final employee1 = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );
      final employee2 = Employee(
        id: '2',
        fullName: 'Jane Smith',
        jobTitle: 'Product Manager',
        country: 'Canada',
        salary: 110000,
      );

      await repository.insertEmployee(employee1);
      await repository.insertEmployee(employee2);

      await repository.deleteEmployee('1');

      final employees = await repository.getAllEmployees();
      expect(employees.length, 1);
      expect(employees.first.id, '2');
    });

    test('should correctly map Employee model to database row', () async {
      final employee = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );

      await repository.insertEmployee(employee);

      final employees = await repository.getAllEmployees();
      final fetchedEmployee = employees.first;

      expect(fetchedEmployee.id, employee.id);
      expect(fetchedEmployee.fullName, employee.fullName);
      expect(fetchedEmployee.jobTitle, employee.jobTitle);
      expect(fetchedEmployee.country, employee.country);
      expect(fetchedEmployee.salary, employee.salary);
    });

    test('should return empty list when no employees exist', () async {
      final employees = await repository.getAllEmployees();
      expect(employees, isEmpty);
    });

    test('should handle updating non-existent employee gracefully', () async {
      final employee = Employee(
        id: '999',
        fullName: 'Non Existent',
        jobTitle: 'Test',
        country: 'Test',
        salary: 0,
      );

      await repository.updateEmployee(employee);

      final employees = await repository.getAllEmployees();
      expect(employees, isEmpty);
    });

    test('should handle deleting non-existent employee gracefully', () async {
      await repository.deleteEmployee('999');

      final employees = await repository.getAllEmployees();
      expect(employees, isEmpty);
    });
  });
}

