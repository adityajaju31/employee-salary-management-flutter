import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/employee.dart';
import '../repositories/employee_repository.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final EmployeeRepository _repository;
  bool _isLoading = false;

  EmployeeCubit(this._repository) : super([]) {
    _loadEmployees();
  }

  bool get isLoading => _isLoading;

  Future<void> _loadEmployees() async {
    _isLoading = true;
    final employees = await _repository.getAllEmployees();
    _isLoading = false;
    emit(employees);
  }

  Future<void> addEmployee(Employee employee) async {
    await _repository.insertEmployee(employee);
    await _loadEmployees();
  }

  Future<void> updateEmployee(Employee updatedEmployee) async {
    await _repository.updateEmployee(updatedEmployee);
    await _loadEmployees();
  }

  Future<void> deleteEmployee(String id) async {
    await _repository.deleteEmployee(id);
    await _loadEmployees();
  }
}

