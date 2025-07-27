import 'package:desklab/data/repositories/activity_repository.dart';
import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  late List<Activity> _activities;

  /// Helper to get the start of the week (Monday) for a given date.
  DateTime _getStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday; // Monday is 1, Sunday is 7
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    return normalizedDate.subtract(Duration(days: dayOfWeek - 1));
  }

  ActivityProvider() {
    _activities = _repository.getInitialActivities();
  }

  /// Returns the master list of all activities.
  List<Activity> get allActivities => _activities;

  /// Get activities for a specific date (ignoring time).
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

  /// Get all activities for the week that contains the given date.
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

  /// Get total hours for a specific date.
  int getTotalHoursForDate(DateTime date) {
    return getActivitiesForDate(
      date,
    ).fold(0, (sum, activity) => sum + activity.hours);
  }

  /// Get total hours for the week that contains the given date.
  int getTotalHoursForWeek(DateTime dateInWeek) {
    return getActivitiesForWeek(
      dateInWeek,
    ).fold(0, (sum, activity) => sum + activity.hours);
  }

  /// Adds a new activity to the list.
  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  /// Updates an existing activity using its unique ID.
  void updateActivity(String activityId, Activity newActivity) {
    final index = _activities.indexWhere((act) => act.id == activityId);
    if (index != -1) {
      _activities[index] = newActivity;
      notifyListeners();
    }
  }

  /// Deletes an activity using its unique ID.
  void deleteActivity(String activityId) {
    _activities.removeWhere((act) => act.id == activityId);
    notifyListeners();
  }
}
