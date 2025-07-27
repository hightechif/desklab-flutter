import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityRepository {
  List<Activity> getInitialActivities() {
    final List<Activity> allActivities = [];

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

    void addFullDayOfActivities(DateTime date) {
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
          hours: 4,
          activityDate: date,
          color: project1['color'] as Color,
        ),
      );
      allActivities.add(
        Activity(
          id: '${date.toIso8601String()}-2',
          project: project2['name'] as String,
          activityName: activityName2,
          hours: 4,
          activityDate: date,
          color: project2['color'] as Color,
        ),
      );
    }

    final daysInJune = DateTime(2025, 7, 0).day;
    for (int i = 1; i <= daysInJune; i++) {
      final date = DateTime(2025, 6, i);
      if (date.weekday >= 1 && date.weekday <= 5) {
        addFullDayOfActivities(date);
      }
    }

    final startOfCurrentWeek = DateTime(2025, 7, 21);
    final daysInJuly = DateTime(2025, 8, 0).day;

    for (int i = 1; i <= daysInJuly; i++) {
      final date = DateTime(2025, 7, i);
      if (date.isBefore(startOfCurrentWeek)) {
        if (date.weekday >= 1 && date.weekday <= 5) {
          addFullDayOfActivities(date);
        }
      }
    }

    return allActivities;
  }
}
