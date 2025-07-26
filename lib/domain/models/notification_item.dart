import 'package:flutter/material.dart';

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
