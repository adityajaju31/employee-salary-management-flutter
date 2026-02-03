import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/employee_cubit.dart';
import 'repositories/employee_repository.dart';
import 'services/database_service.dart';
import 'employee_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final DatabaseService _databaseService;
  late final EmployeeRepository _repository;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _repository = EmployeeRepository(_databaseService);
  }

  @override
  void dispose() {
    _databaseService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(_repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const EmployeeListPage(),
      ),
    );
  }
}
