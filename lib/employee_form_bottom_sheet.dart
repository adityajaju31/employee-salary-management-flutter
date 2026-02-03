import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/employee_cubit.dart';
import 'models/employee.dart';

class EmployeeFormBottomSheet extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormBottomSheet({super.key, this.employee});

  @override
  State<EmployeeFormBottomSheet> createState() => _EmployeeFormBottomSheetState();
}

class _EmployeeFormBottomSheetState extends State<EmployeeFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _countryController;
  late final TextEditingController _salaryController;

  bool _isEditMode = false;

  bool _isFormValid() {
    return _fullNameController.text.trim().isNotEmpty &&
        _jobTitleController.text.trim().isNotEmpty &&
        _countryController.text.trim().isNotEmpty &&
        _salaryController.text.trim().isNotEmpty &&
        int.tryParse(_salaryController.text) != null &&
        int.parse(_salaryController.text) > 0;
  }

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.employee != null;
    _fullNameController = TextEditingController(text: widget.employee?.fullName ?? '');
    _jobTitleController = TextEditingController(text: widget.employee?.jobTitle ?? '');
    _countryController = TextEditingController(text: widget.employee?.country ?? '');
    _salaryController = TextEditingController(
      text: widget.employee?.salary.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _countryController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditMode ? 'Edit Employee' : 'Add Employee',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        hintText: 'Enter job title',
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Job title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        hintText: 'Enter country',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Country is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        hintText: 'Enter salary',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Salary is required';
                        }
                        final salary = int.tryParse(value);
                        if (salary == null || salary <= 0) {
                          return 'Please enter a valid salary';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _isFormValid()
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                final cubit = context.read<EmployeeCubit>();
                                final salary = int.parse(_salaryController.text);

                                if (_isEditMode && widget.employee != null) {
                                  final updatedEmployee = widget.employee!.copyWith(
                                    fullName: _fullNameController.text.trim(),
                                    jobTitle: _jobTitleController.text.trim(),
                                    country: _countryController.text.trim(),
                                    salary: salary,
                                  );
                                  cubit.updateEmployee(updatedEmployee);
                                } else {
                                  final newEmployee = Employee(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    fullName: _fullNameController.text.trim(),
                                    jobTitle: _jobTitleController.text.trim(),
                                    country: _countryController.text.trim(),
                                    salary: salary,
                                  );
                                  cubit.addEmployee(newEmployee);
                                }

                                Navigator.of(context).pop();
                              }
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isEditMode ? 'Update Employee' : 'Add Employee'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

