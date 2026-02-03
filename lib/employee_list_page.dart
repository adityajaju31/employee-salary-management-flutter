import 'package:flutter/material.dart';
import 'employee_card.dart';
import 'employee_form_bottom_sheet.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  static const _mockEmployees = [
    {
      'fullName': 'John Doe',
      'jobTitle': 'Software Engineer',
      'country': 'United States',
      'salary': 95000,
    },
    {
      'fullName': 'Jane Smith',
      'jobTitle': 'Product Manager',
      'country': 'Canada',
      'salary': 110000,
    },
    {
      'fullName': 'Ahmed Hassan',
      'jobTitle': 'UX Designer',
      'country': 'Egypt',
      'salary': 75000,
    },
    {
      'fullName': 'Maria Garcia',
      'jobTitle': 'Data Scientist',
      'country': 'Spain',
      'salary': 105000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth > 600;
          final padding = isTablet ? 16.0 : 12.0;
          final maxContentWidth = isTablet ? 1200.0 : double.infinity;

          if (_mockEmployees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No employees yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add your first employee',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: isTablet
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _mockEmployees.length,
                        itemBuilder: (context, index) => EmployeeCard(
                          employee: _mockEmployees[index],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _mockEmployees.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => EmployeeCard(
                          employee: _mockEmployees[index],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EmployeeListPage.showEmployeeForm(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  static void showEmployeeForm(BuildContext context, Map<String, dynamic>? employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => EmployeeFormBottomSheet(employee: employee),
    );
  }
}

