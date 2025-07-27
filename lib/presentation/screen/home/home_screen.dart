import 'package:desklab/data/repositories/calendar_event_repository';
import 'package:desklab/domain/models/calendar_event.dart';
import 'package:desklab/presentation/providers/activity_provider.dart';
import 'package:desklab/presentation/screen/home/leave/leave_screen.dart';
import 'package:desklab/presentation/screen/home/specialwork/special_work_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Semua';
  late List<CalendarEvent> _allEvents;
  late List<CalendarEvent> _filteredEvents;
  final CalendarEventRepository _eventRepository = CalendarEventRepository();

  @override
  void initState() {
    super.initState();
    _allEvents = _eventRepository.getEvents();
    _updateFilteredEvents();
  }

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _updateFilteredEvents();
    });
  }

  void _updateFilteredEvents() {
    if (_selectedFilter == 'Semua') {
      _filteredEvents = _allEvents;
    } else {
      _filteredEvents =
          _allEvents
              .where(
                (event) =>
                    event.category.toLowerCase() ==
                    _selectedFilter.toLowerCase(),
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider to get real-time updates for the weekly hours.
    final activityProvider = Provider.of<ActivityProvider>(context);
    int weeklyHours = 0;
    activityProvider.activitiesByDay.forEach((day, activities) {
      for (var activity in activities) {
        weeklyHours += activity.hours;
      }
    });

    return Scaffold(
      body: SafeArea(
        // Use a Column to separate static content from the scrollable list
        child: Column(
          children: [
            // --- START: NON-SCROLLABLE CONTENT ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Pass the dynamic weekly hours to the card widget.
                  _buildWeeklyActivityCard(context, weeklyHours),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 24),
                  _buildCalendarHeader(),
                ],
              ),
            ),
            // --- END: NON-SCROLLABLE CONTENT ---

            // --- START: SCROLLABLE LIST ---
            Expanded(
              child:
                  _filteredEvents.isEmpty
                      ? _buildEmptyCalendarView()
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          final bool showDate =
                              index == 0 ||
                              _filteredEvents[index - 1].day != event.day;
                          return _buildEventTile(event, showDate);
                        },
                      ),
            ),
            // --- END: SCROLLABLE LIST ---
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

  Widget _buildWeeklyActivityCard(BuildContext context, int weeklyHours) {
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
              child: const Icon(Icons.library_books, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aktivitas Minggu Ini',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$weeklyHours dari 40 jam aktivitas',
                    style: const TextStyle(color: Colors.grey),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(icon, color: const Color(0xFF333333)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    const filters = ['Semua', 'Cuti', 'Kerja Khusus', 'Libur', 'Ulang Tahun'];
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
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Divisi Dropdown (static for now)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  avatar: const Icon(Icons.arrow_drop_down, size: 18),
                  label: const Text('Divisi'),
                  backgroundColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.grey),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              ...filters.map((label) {
                final isSelected = _selectedFilter == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => _updateFilter(label),
                    child: Chip(
                      label: Text(label),
                      backgroundColor:
                          isSelected ? const Color(0xFFFEE2E1) : Colors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected ? const Color(0xFFD32F2F) : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color:
                            isSelected
                                ? const Color(0xFFD32F2F)
                                : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEventTile(CalendarEvent event, bool showDate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date part, shown only for the first item of the day
          SizedBox(
            width: 50,
            child:
                showDate
                    ? Column(
                      children: [
                        Text(
                          event.day,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          event.month,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                    : null,
          ),
          const SizedBox(width: 8),
          // Event details card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: event.color, width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          event.type,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCalendarView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.business, size: 32, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Data Terkini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nantikan update informasi terbaru disini atau coba gunakan filter lainnya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
