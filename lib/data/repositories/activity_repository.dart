import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityRepository {
  // This is where you would typically make an API call.
  // For now, we'll return the same hardcoded data.
  Map<int, List<Activity>> getInitialActivities() {
    return {
      0: [
        // Monday, July 14
        Activity(
          project: 'KLIK-CORP-KLIK-DEVELOPMENT',
          activityName: 'Enhancement',
          hours: 4,
          color: const Color(0xFF546E7A),
        ),
        Activity(
          project: 'KLIK-CORP-KLIK-DEVELOPMENT',
          activityName: 'Development',
          hours: 4,
          color: const Color(0xFF546E7A),
        ),
      ],
      1: [
        // Tuesday, July 15
        Activity(
          project: 'EDTS-ADMIN-ADMIN-TRAINING',
          activityName: 'Sharing Session',
          hours: 8,
          color: Colors.brown,
        ),
      ],
      2: [
        // Wednesday, July 16
        Activity(
          project: 'GURIH-CORP-GURIHMART-DEV',
          activityName: 'Bugs Fixing',
          hours: 8,
          color: const Color(0xFF62727b),
        ),
      ],
      3: [
        // Thursday, July 17
        Activity(
          project: 'EDTS-ADMIN-ADMIN-LEAVE',
          activityName: 'Annual Leave',
          hours: 8,
          color: Colors.purple,
        ),
      ],
      4: [
        // Friday, July 18
        Activity(
          project: 'KLIK-CORP-KLIK-DEVELOPMENT',
          activityName: 'Research / Planning',
          hours: 8,
          color: const Color(0xFF4A6572),
        ),
      ],
    };
  }
}
