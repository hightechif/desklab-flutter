import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String project;
  final String activityName;
  final int hours;
  final DateTime activityDate;
  final Color color;
  String? notes;

  Activity({
    required this.id,
    required this.project,
    required this.activityName,
    required this.hours,
    required this.activityDate,
    required this.color,
    this.notes,
  });
}
