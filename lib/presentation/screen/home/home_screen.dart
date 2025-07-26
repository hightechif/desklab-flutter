import 'package:desklab/domain/models/calendar_event.dart';
import 'package:desklab/presentation/screen/home/leave/leave_screen.dart';
import 'package:desklab/presentation/screen/home/specialwork/special_work_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildWeeklyActivityCard(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            _buildCalendarSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFEFEFEF),
          child: ClipOval(
            child: Image.network(
              'https://placehold.co/100x100/EFEFEF/333333?text=RF',
              fit: BoxFit.cover,
              width: 48.0,
              height: 48.0,
              errorBuilder:
                  (context, error, stackTrace) => const Center(
                    child: Text(
                      'RF',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              loadingBuilder:
                  (context, child, progress) =>
                      progress == null
                          ? child
                          : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Pagi,',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Ridhan Fadhilah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyActivityCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/activity-details'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktivitas Minggu Ini',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '9 dari 40 jam aktivitas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            label: 'Ajukan\nCuti',
            icon: Icons.calendar_today,
            screen: const LeaveScreen(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            label: 'Ajukan\nKerja Khusus',
            icon: Icons.business_center,
            screen: const SpecialWorkScreen(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(icon, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    final events = [
      CalendarEvent(
        '28',
        'Jul',
        'Yovita Liana Salsabila',
        'Cuti Melahirkan',
        const Color(0xFF2196F3),
      ),
      CalendarEvent(
        '28',
        'Jul',
        'Kevin Edbert J',
        'Cuti Tahunan (Siang)',
        const Color(0xFF2196F3),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kalender Minggu Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('Selengkapnya')),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                ['Semua', 'Cuti', 'Kerja Khusus', 'Libur', 'Ulang Tahun']
                    .map(
                      (label) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(label),
                          backgroundColor:
                              label == 'Semua'
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.white,
                          labelStyle: TextStyle(
                            color: label == 'Semua' ? Colors.blue : Colors.grey,
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) => _buildEventTile(events[index]),
        ),
      ],
    );
  }

  Widget _buildEventTile(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  event.day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(event.month, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 4, height: 40, color: event.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(event.type, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
