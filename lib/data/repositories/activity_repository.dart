import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ActivityRepository {
  List<Activity> getInitialActivities() {
    final List<Activity> allActivities = [];

    // Define some dummy project/activity details for variety
    final dummyProjects = [
      {'name': 'KLIK-CORP-KLIK-DEVELOPMENT', 'color': const Color(0xFF546E7A)},
      {'name': 'EDTS-ADMIN-ADMIN-TRAINING', 'color': const Color(0xFF00BCD4)},
      {'name': 'GURIH-CORP-GURIHMART-DEV', 'color': Colors.brown},
      {'name': 'EDTS-ADMIN-ADMIN-LEAVE', 'color': Colors.purple},
    ];
    final dummyActivityNames = [
      'Development',
      'Enhancement',
      'Bugs Fixing',
      'Weekly Meeting',
      'Sharing Session',
      'Research / Planning',
    ];

    // Helper to add a full 8-hour day of activities for a given date.
    void addFullDayOfActivities(DateTime date) {
      // Use the day of the month to add some variety to the created activities.
      final project1 = dummyProjects[date.day % dummyProjects.length];
      final project2 = dummyProjects[(date.day + 1) % dummyProjects.length];
      final activityName1 =
          dummyActivityNames[date.day % dummyActivityNames.length];
      final activityName2 =
          dummyActivityNames[(date.day + 1) % dummyActivityNames.length];

      allActivities.add(
        Activity(
          id: '${date.toIso8601String()}-1',
          project: project1['name'] as String,
          activityName: activityName1,
          hours: 4, // First 4 hours
          activityDate: date,
          color: project1['color'] as Color,
        ),
      );
      allActivities.add(
        Activity(
          id: '${date.toIso8601String()}-2',
          project: project2['name'] as String,
          activityName: activityName2,
          hours: 4, // Second 4 hours
          activityDate: date,
          color: project2['color'] as Color,
        ),
      );
    }

    // --- Generate June 2025 Data ---
    // Fill every weekday in June with 8 hours of activity.
    final daysInJune = DateTime(2025, 7, 0).day; // Get number of days in June
    for (int i = 1; i <= daysInJune; i++) {
      final date = DateTime(2025, 6, i);
      // Check if it's a weekday (Monday=1, Friday=5)
      if (date.weekday >= 1 && date.weekday <= 5) {
        addFullDayOfActivities(date);
      }
    }

    // --- Generate July 2025 Data ---
    // The current date is assumed to be July 27, 2025.
    // The current week is Mon, Jul 21 to Sun, Jul 27.
    // We need to fill data for all weekdays *before* the current week.
    final startOfCurrentWeek = DateTime(2025, 7, 21);
    final daysInJuly = DateTime(2025, 8, 0).day;

    for (int i = 1; i <= daysInJuly; i++) {
      final date = DateTime(2025, 7, i);
      // Only add data for dates before the start of the current week.
      if (date.isBefore(startOfCurrentWeek)) {
        // And only for weekdays.
        if (date.weekday >= 1 && date.weekday <= 5) {
          addFullDayOfActivities(date);
        }
      }
    }

    return allActivities;
  }
}
