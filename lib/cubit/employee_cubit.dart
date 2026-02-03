import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/employee.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  EmployeeCubit() : super(_initialEmployees());

  static List<Employee> _initialEmployees() {
    return [
      Employee(
        id: '1',
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        country: 'United States',
        salary: 95000,
      ),
      Employee(
        id: '2',
        fullName: 'Jane Smith',
        jobTitle: 'Product Manager',
        country: 'Canada',
        salary: 110000,
      ),
      Employee(
        id: '3',
        fullName: 'Ahmed Hassan',
        jobTitle: 'UX Designer',
        country: 'Egypt',
        salary: 75000,
      ),
      Employee(
        id: '4',
        fullName: 'Maria Garcia',
        jobTitle: 'Data Scientist',
        country: 'Spain',
        salary: 105000,
      ),
    ];
  }

  void addEmployee(Employee employee) {
    emit([...state, employee]);
  }

  void updateEmployee(Employee updatedEmployee) {
    emit(state.map((employee) {
      return employee.id == updatedEmployee.id ? updatedEmployee : employee;
    }).toList());
  }

  void deleteEmployee(String id) {
    emit(state.where((employee) => employee.id != id).toList());
  }
}

