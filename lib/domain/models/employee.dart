import 'package:flutter/material.dart';

class Employee {
  final String name;
  final String title;
  final String imageUrl;
  final String phone;
  final String email;
  final String employeeId;
  final String department;
  final String division;
  final String joinDate;

  Employee({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.phone,
    required this.email,
    required this.employeeId,
    required this.department,
    required this.division,
    required this.joinDate,
  });
}

class NotificationItem {
  final String category;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBgColor;

  NotificationItem({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBgColor,
  });
}
