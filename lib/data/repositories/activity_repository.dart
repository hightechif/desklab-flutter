import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ActivityRepository {
  // CHANGED: The method now returns a flat List<Activity> instead of a Map.
  List<Activity> getInitialActivities() {
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

    final List<dynamic> parsedJson = jsonDecode(apiResponse);
    final List<Activity> allActivities = [];

    Color hexToColor(String code) {
      try {
        return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
      } catch (e) {
        return Colors.grey;
      }
    }

    for (var projectActivityJson in parsedJson) {
      final String project =
          '${projectActivityJson['clientName']}-${projectActivityJson['clientDivisionName']}-${projectActivityJson['clientProjectName']}-${projectActivityJson['clientSubProjectName']}';
      final String activityName = projectActivityJson['activityName'];
      final Color color = hexToColor(projectActivityJson['hexCode']);

      for (var activityLogJson in projectActivityJson['activities']) {
        final DateTime activityDate = DateTime.parse(
          activityLogJson['activityDate'],
        );

        final activity = Activity(
          id: activityLogJson['id'],
          project: project,
          activityName: activityName,
          hours: activityLogJson['workHour'],
          activityDate: activityDate,
          color: color,
          notes: null,
        );
        allActivities.add(activity);
      }
    }
    return allActivities;
  }
}
