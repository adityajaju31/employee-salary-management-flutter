class Employee {
  final String id;
  final String fullName;
  final String jobTitle;
  final String country;
  final int salary;

  Employee({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.country,
    required this.salary,
  });

  Employee copyWith({
    String? id,
    String? fullName,
    String? jobTitle,
    String? country,
    int? salary,
  }) {
    return Employee(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      country: country ?? this.country,
      salary: salary ?? this.salary,
    );
  }
}

