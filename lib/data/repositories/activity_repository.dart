import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// --- Activity Repository ---
class ActivityRepository {
  /// Parses the new API response and transforms it into the Map structure
  /// expected by the ActivityProvider.
  Map<int, List<Activity>> getInitialActivities() {
    // The JSON data provided by the user, embedded as a string.
    const apiResponse = '''
    [
      {
        "projectId": 422,
        "clientName": "KLIK",
        "clientDivisionName": "CORP",
        "clientProjectName": "KLIK",
        "clientSubProjectName": "DEVELOPMENT",
        "activityId": 68,
        "activityName": "Enhancement",
        "hexCode": "#546E7A",
        "activities": [
          {
            "id": "ce2c71ef-6468-43d4-9f35-8280845b8c2e",
            "projectId": 422,
            "activityId": 68,
            "activityDate": "2025-07-15",
            "workHour": 4
          },
          {
            "id": "dcb36409-79cd-41e9-86f7-c4e0a0d44e01",
            "projectId": 422,
            "activityId": 68,
            "activityDate": "2025-07-18",
            "workHour": 2
          }
        ]
      },
      {
        "projectId": 556,
        "clientName": "EDTS",
        "clientDivisionName": "ADMIN",
        "clientProjectName": "ADMIN",
        "clientSubProjectName": "ROUTINE",
        "activityId": 122,
        "activityName": "Weekly Meeting",
        "hexCode": "#00BCD4",
        "activities": [
          {
            "id": "2fc94eb0-6a77-4658-88ee-a59333c53036",
            "projectId": 556,
            "activityId": 122,
            "activityDate": "2025-07-18",
            "workHour": 1
          }
        ]
      },
      {
        "projectId": 422,
        "clientName": "KLIK",
        "clientDivisionName": "CORP",
        "clientProjectName": "KLIK",
        "clientSubProjectName": "DEVELOPMENT",
        "activityId": 65,
        "activityName": "Bugs Fixing",
        "hexCode": "#546E7A",
        "activities": [
          {
            "id": "fe2f79a6-29ab-48c0-b7d9-88a0f7574297",
            "projectId": 422,
            "activityId": 65,
            "activityDate": "2025-07-18",
            "workHour": 2
          }
        ]
      },
      {
        "projectId": 422,
        "clientName": "KLIK",
        "clientDivisionName": "CORP",
        "clientProjectName": "KLIK",
        "clientSubProjectName": "DEVELOPMENT",
        "activityId": 67,
        "activityName": "Development",
        "hexCode": "#546E7A",
        "activities": [
          {
            "id": "46d3cdeb-9a46-49b9-89e0-acda704456ea",
            "projectId": 422,
            "activityId": 67,
            "activityDate": "2025-07-15",
            "workHour": 4
          },
          {
            "id": "b6950889-f41e-47bd-9a34-55eec65cc84b",
            "projectId": 422,
            "activityId": 67,
            "activityDate": "2025-07-18",
            "workHour": 4
          }
        ]
      }
    ]
    ''';

    // Decode the JSON string into a List of dynamic objects.
    final List<dynamic> parsedJson = jsonDecode(apiResponse);

    // This map will hold the final, structured data.
    final Map<int, List<Activity>> activitiesByDay = {};

    // Helper function to convert a hex color string (e.g., "#546E7A") to a Color object.
    Color hexToColor(String code) {
      try {
        return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
      } catch (e) {
        return Colors.grey; // Fallback color
      }
    }

    // Iterate over each project group in the JSON response.
    for (var projectActivityJson in parsedJson) {
      // Extract parent-level information that applies to all nested activities.
      final String project =
          '${projectActivityJson['clientName']}-${projectActivityJson['clientDivisionName']}-${projectActivityJson['clientProjectName']}-${projectActivityJson['clientSubProjectName']}';
      final String activityName = projectActivityJson['activityName'];
      final Color color = hexToColor(projectActivityJson['hexCode']);

      // Iterate through the nested 'activities' list (the individual work logs).
      for (var activityLogJson in projectActivityJson['activities']) {
        // Parse the date string into a DateTime object.
        final DateTime activityDate = DateTime.parse(
          activityLogJson['activityDate'],
        );
        // Determine the day of the week (0 for Monday, 6 for Sunday).
        final int dayIndex = activityDate.weekday - 1;

        // Create a new Activity instance with combined data.
        final activity = Activity(
          id: activityLogJson['id'],
          project: project,
          activityName: activityName,
          hours: activityLogJson['workHour'],
          activityDate: activityDate,
          color: color,
          notes: null, // 'notes' field is not present in the API response.
        );

        // Add the created activity to our map, grouped by the day index.
        if (activitiesByDay.containsKey(dayIndex)) {
          activitiesByDay[dayIndex]!.add(activity);
        } else {
          activitiesByDay[dayIndex] = [activity];
        }
      }
    }
    return activitiesByDay;
  }
}
