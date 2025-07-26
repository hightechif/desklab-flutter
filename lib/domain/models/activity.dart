import 'package:flutter/material.dart';

class Activity {
  String project;
  String activityName;
  int hours;
  String? notes;
  Color color;

  Activity({
    required this.project,
    required this.activityName,
    required this.hours,
    this.notes,
    this.color = Colors.brown,
  });
}
