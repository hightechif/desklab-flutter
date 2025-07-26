import 'package:desklab/domain/models/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = {
      'Jumat, 25 Juli 2025': [
        NotificationItem(
          category: 'AKTIVITAS',
          title: 'Pengingat Pengisian Aktivitas',
          description: 'Aktivitas Anda pekan ini kurang dari 40 jam...',
          icon: Icons.task,
          iconBgColor: Colors.orange,
        ),
      ],
      'Rabu, 23 Juli 2025': [
        NotificationItem(
          category: 'CUTI',
          title: 'Persetujuan Cuti',
          description:
              'Robert Maramis Setiawan telah menyetujui Cuti Tahunan...',
          icon: Icons.calendar_today,
          iconBgColor: Colors.blue,
        ),
      ],
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ['Semua', 'Cuti', 'Kerja Khusus', 'Delegasi', 'Aktivitas']
                        .map(
                          (label) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(label),
                              backgroundColor:
                                  label == 'Semua'
                                      ? Colors.black
                                      : Colors.white,
                              labelStyle: TextStyle(
                                color:
                                    label == 'Semua'
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.keys.length,
            itemBuilder: (context, index) {
              final date = notifications.keys.elementAt(index);
              final notifList = notifications[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifList.length,
                    itemBuilder: (context, notifIndex) {
                      final notif = notifList[notifIndex];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.category,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notif.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
