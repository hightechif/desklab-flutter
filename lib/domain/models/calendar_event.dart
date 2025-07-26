import 'package:flutter/material.dart';

class CalendarEvent {
  final String day;
  final String month;
  final String name;
  final String type;
  final Color color;
  final String category; // Added for filtering

  CalendarEvent(
    this.day,
    this.month,
    this.name,
    this.type,
    this.color,
    this.category,
  );
}
