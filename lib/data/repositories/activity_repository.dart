import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityRepository {
  // This is where you would typically make an API call.
  // For now, we'll return the same hardcoded data.
  Map<int, List<Activity>> getInitialActivities() {
    return {
      0: [
        // Monday
        Activity(
          project: 'EDTS-ADMIN-ADMIN-TRAINING',
          activityName: 'Sharing Session',
          hours: 5,
          color: Colors.brown,
        ),
        Activity(
          project: 'KLIK-CORP-KLIK-DEVELOPMENT',
          activityName: 'Development',
          hours: 4,
          color: const Color(0xFF4A6572),
        ),
      ],
      2: [
        // Wednesday
        Activity(
          project: 'EDTS-ADMIN-ADMIN-LEAVE',
          activityName: 'Annual Leave',
          hours: 4,
          color: Colors.purple,
        ),
      ],
    };
  }
}
