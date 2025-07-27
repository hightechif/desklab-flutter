import 'package:flutter/material.dart';

class Activity {
  final String? id; // Null for new activities not yet saved to a backend
  final String project;
  final String activityName;
  final int hours;
  final DateTime activityDate;
  final Color color;
  String? notes;

  Activity({
    this.id,
    required this.project,
    required this.activityName,
    required this.hours,
    required this.activityDate,
    required this.color,
    this.notes,
  });
}
