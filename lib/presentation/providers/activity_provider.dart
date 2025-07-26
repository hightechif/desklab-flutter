import 'package:desklab/data/repositories/activity_repository.dart';
import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  late Map<int, List<Activity>> _activitiesByDay;

  ActivityProvider() {
    _activitiesByDay = _repository.getInitialActivities();
  }

  Map<int, List<Activity>> get activitiesByDay => _activitiesByDay;

  List<Activity> getActivitiesForDay(int dayIndex) {
    return _activitiesByDay[dayIndex] ?? [];
  }

  void addActivity(int dayIndex, Activity activity) {
    if (_activitiesByDay.containsKey(dayIndex)) {
      _activitiesByDay[dayIndex]!.add(activity);
    } else {
      _activitiesByDay[dayIndex] = [activity];
    }
    notifyListeners();
  }

  void updateActivity(int dayIndex, int listIndex, Activity activity) {
    if (_activitiesByDay.containsKey(dayIndex)) {
      _activitiesByDay[dayIndex]![listIndex] = activity;
      notifyListeners();
    }
  }

  void deleteActivity(int dayIndex, int listIndex) {
    if (_activitiesByDay.containsKey(dayIndex)) {
      _activitiesByDay[dayIndex]!.removeAt(listIndex);
      if (_activitiesByDay[dayIndex]!.isEmpty) {
        _activitiesByDay.remove(dayIndex);
      }
      notifyListeners();
    }
  }
}
