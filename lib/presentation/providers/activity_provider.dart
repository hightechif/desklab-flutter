import 'package:desklab/data/repositories/activity_repository.dart';
import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  late List<Activity> _activities;

  DateTime _getStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    return normalizedDate.subtract(Duration(days: dayOfWeek - 1));
  }

  ActivityProvider() {
    _activities = _repository.getInitialActivities();
  }

  List<Activity> get allActivities => _activities;

  List<Activity> getActivitiesForDate(DateTime date) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    return _activities
        .where(
          (activity) =>
              DateTime.utc(
                activity.activityDate.year,
                activity.activityDate.month,
                activity.activityDate.day,
              ) ==
              normalizedDate,
        )
        .toList();
  }

  List<Activity> getActivitiesForWeek(DateTime dateInWeek) {
    final startOfWeek = _getStartOfWeek(dateInWeek);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return _activities.where((activity) {
      final activityDate = DateTime.utc(
        activity.activityDate.year,
        activity.activityDate.month,
        activity.activityDate.day,
      );
      return activityDate.isAfter(
            startOfWeek.subtract(const Duration(microseconds: 1)),
          ) &&
          activityDate.isBefore(endOfWeek);
    }).toList();
  }

  int getTotalHoursForDate(DateTime date) {
    return getActivitiesForDate(
      date,
    ).fold(0, (sum, activity) => sum + activity.hours);
  }

  int getTotalHoursForWeek(DateTime dateInWeek) {
    return getActivitiesForWeek(
      dateInWeek,
    ).fold(0, (sum, activity) => sum + activity.hours);
  }

  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void updateActivity(String activityId, Activity newActivity) {
    final index = _activities.indexWhere((act) => act.id == activityId);
    if (index != -1) {
      _activities[index] = newActivity;
      notifyListeners();
    }
  }

  void deleteActivity(String activityId) {
    _activities.removeWhere((act) => act.id == activityId);
    notifyListeners();
  }

  // ADDED: Method to add a list of activities and notify listeners once.
  void addActivities(List<Activity> activities) {
    _activities.addAll(activities);
    notifyListeners();
  }

  // ADDED: Method to find the last workday with any recorded activity.
  DateTime? findLastWorkdayWithActivity(DateTime fromDate) {
    var currentDate = DateTime.utc(
      fromDate.year,
      fromDate.month,
      fromDate.day,
    ).subtract(const Duration(days: 1));
    for (int i = 0; i < 90; i++) {
      // Search back up to 90 days
      if (currentDate.weekday >= 1 && currentDate.weekday <= 5) {
        if (getActivitiesForDate(currentDate).isNotEmpty) {
          return currentDate;
        }
      }
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    return null;
  }

  // ADDED: Method to handle the core logic of copying activities.
  bool copyActivities({required DateTime from, required DateTime to}) {
    final activitiesToCopy = getActivitiesForDate(from);

    if (activitiesToCopy.isEmpty) {
      return false;
    }

    final List<Activity> newActivities = [];
    for (final activity in activitiesToCopy) {
      newActivities.add(
        Activity(
          id: '${DateTime.now().toIso8601String()}-${activity.id}',
          project: activity.project,
          activityName: activity.activityName,
          hours: activity.hours,
          activityDate: to,
          color: activity.color,
          notes: activity.notes,
        ),
      );
    }
    addActivities(newActivities);
    return true;
  }
}
