import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class ReportTabView extends StatelessWidget {
  final bool isWeekly;
  const ReportTabView({super.key, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    final totalHours = isWeekly ? 9 : 13;
    final maxHours = isWeekly ? 40 : 184;
    final activities = [
      Activity(
        id: 'dummy-1',
        project: 'EDTS-ADMIN-ADMIN-LEAVE',
        activityName: 'Annual Leave',
        hours: 4,
        color: Colors.purple,
        activityDate: DateTime.now(),
      ),
      Activity(
        id: 'dummy-2',
        project: 'EDTS-ADMIN-ADMIN-TRAINING',
        activityName: 'Sharing Session',
        hours: 5,
        color: Colors.brown,
        activityDate: DateTime.now(),
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...activities.map(
                (activity) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: activity.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activity.project,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${activity.hours} Jam',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activity.activityName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${activity.hours} Jam',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jam Kerja ${isWeekly ? 'Mingguan' : 'Bulanan'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$totalHours/$maxHours',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalHours / maxHours,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
