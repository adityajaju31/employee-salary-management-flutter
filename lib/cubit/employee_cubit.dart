import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/employee.dart';
import '../repositories/employee_repository.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository _repository;

  EmployeeCubit(this._repository) : super(const EmployeeState(employees: [], isLoading: true)) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final employees = await _repository.getAllEmployees();
      emit(state.copyWith(employees: employees, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load employees: ${e.toString()}',
      ));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _repository.insertEmployee(employee);
      await loadEmployees();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add employee: ${e.toString()}'));
    }
  }

  Future<void> updateEmployee(Employee updatedEmployee) async {
    try {
      await _repository.updateEmployee(updatedEmployee);
      await loadEmployees();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update employee: ${e.toString()}'));
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _repository.deleteEmployee(id);
      await loadEmployees();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete employee: ${e.toString()}'));
    }
  }
}

