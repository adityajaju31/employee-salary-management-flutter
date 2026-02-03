import 'package:flutter_test/flutter_test.dart';
import 'package:employee_salary_app/models/employee.dart';

void main() {
  group('Employee', () {
    test('should create a valid employee with all required fields', () {
      final employee = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );

      expect(employee.id, '1');
      expect(employee.fullName, 'John Doe');
      expect(employee.jobTitle, 'Software Engineer');
      expect(employee.country, 'United States');
      expect(employee.salary, 95000);
    });

    test('should require id field', () {
      expect(
        () => Employee(
          id: '',
          fullName: 'John Doe',
          jobTitle: 'Software Engineer',
          country: 'United States',
          salary: 95000,
        ),
        returnsNormally,
      );
    });

    test('should require fullName field', () {
      expect(
        () => Employee(
          id: '1',
          fullName: '',
          jobTitle: 'Software Engineer',
          country: 'United States',
          salary: 95000,
        ),
        returnsNormally,
      );
    });

    test('should require jobTitle field', () {
      expect(
        () => Employee(
          id: '1',
          fullName: 'John Doe',
          jobTitle: '',
          country: 'United States',
          salary: 95000,
        ),
        returnsNormally,
      );
    });

    test('should require country field', () {
      expect(
        () => Employee(
          id: '1',
          fullName: 'John Doe',
          jobTitle: 'Software Engineer',
          country: '',
          salary: 95000,
        ),
        returnsNormally,
      );
    });

    test('should require salary field', () {
      expect(
        () => Employee(
          id: '1',
          fullName: 'John Doe',
          jobTitle: 'Software Engineer',
          country: 'United States',
          salary: 0,
        ),
        returnsNormally,
      );
    });

    test('should serialize employee to map', () {
      final employee = Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      );

      final map = employee.toMap();

      expect(map, {
        'id': '1',
        'fullName': 'John Doe',
        'jobTitle': 'Software Engineer',
        'country': 'United States',
        'salary': 95000,
      });
    });

    test('should deserialize employee from map', () {
      final map = {
        'id': '1',
        'fullName': 'John Doe',
        'jobTitle': 'Software Engineer',
        'country': 'United States',
        'salary': 95000,
      };

      final employee = Employee.fromMap(map);

      expect(employee.id, '1');
      expect(employee.fullName, 'John Doe');
      expect(employee.jobTitle, 'Software Engineer');
      expect(employee.country, 'United States');
      expect(employee.salary, 95000);
    });

    test('should handle salary as int in map', () {
      final map = {
        'id': '1',
        'fullName': 'John Doe',
        'jobTitle': 'Software Engineer',
        'country': 'United States',
        'salary': 95000,
      };

      final employee = Employee.fromMap(map);

      expect(employee.salary, isA<int>());
      expect(employee.salary, 95000);
    });

    test('should create equal employees from same map', () {
      final map = {
        'id': '1',
        'fullName': 'John Doe',
        'jobTitle': 'Software Engineer',
        'country': 'United States',
        'salary': 95000,
      };

      final employee1 = Employee.fromMap(map);
      final employee2 = Employee.fromMap(map);

      expect(employee1.id, employee2.id);
      expect(employee1.fullName, employee2.fullName);
      expect(employee1.jobTitle, employee2.jobTitle);
      expect(employee1.country, employee2.country);
      expect(employee1.salary, employee2.salary);
    });
  });
}

