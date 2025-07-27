import 'package:desklab/domain/models/activity.dart';
import 'package:desklab/presentation/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_activity_screen.dart';
import 'report/report_screen.dart';
import 'package:intl/intl.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key});
  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  // State for the calendar
  bool _isCalendarOpen = false;
  // Set initial date to match the screenshots for consistency
  DateTime _selectedDate = DateTime(2025, 7, 21);
  late DateTime _displayMonth;

  // Getter for the selected day index (0=Monday, 6=Sunday)
  int get _selectedDayIndex => _selectedDate.weekday - 1;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  /// Toggles the visibility of the month calendar view.
  void _toggleCalendar() {
    setState(() {
      _isCalendarOpen = !_isCalendarOpen;
    });
  }

  /// Changes the displayed month in the calendar view.
  void _changeMonth(int increment) {
    setState(() {
      _displayMonth = DateTime(
        _displayMonth.year,
        _displayMonth.month + increment,
      );
    });
  }

  /// Updates the selected date and closes the calendar.
  void _selectDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      // Also update the display month to match the newly selected date
      _displayMonth = DateTime(newDate.year, newDate.month);
      _isCalendarOpen = false; // Close calendar on date selection
    });
  }

  /// Helper to get the ISO week number for a given date.
  int getWeekOfYear(DateTime date) {
    final dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// Helper to get all DateTime objects for the week of a given date.
  List<DateTime> getDaysInWeek(DateTime date) {
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final currentActivities = activityProvider.getActivitiesForDay(
      _selectedDayIndex,
    );

    int dailyHours = 0;
    for (var activity in currentActivities) {
      dailyHours += activity.hours;
    }

    int weeklyHours = 0;
    activityProvider.activitiesByDay.forEach((day, activities) {
      for (var activity in activities) {
        weeklyHours += activity.hours;
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Aktivitas Anda',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                ),
            icon: const Icon(Icons.bar_chart, color: Colors.black),
            label: const Text('Laporan', style: TextStyle(color: Colors.black)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          if (_isCalendarOpen)
            _buildMonthCalendar()
          else
            // Use Expanded to make the ListView take the remaining space
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  _buildWeekSelector(),
                  const SizedBox(height: 24),
                  _buildDailyHoursCard(dailyHours),
                  const SizedBox(height: 24),
                  currentActivities.isEmpty
                      ? _buildNoActivityView()
                      : _buildActivityList(currentActivities),
                ],
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddActivityScreen(),
              ),
            );
            if (result != null && result is Activity) {
              activityProvider.addActivity(_selectedDayIndex, result);
              _showSuccessSnackbar("Anda berhasil menambahkan aktivitas");
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Tambah Aktivitas'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      bottomSheet: _buildWeeklyProgress(weeklyHours),
    );
  }

  /// Builds the header with the month, year, and toggle/navigation arrows.
  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _toggleCalendar,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy', 'id_ID').format(_displayMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isCalendarOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
          if (_isCalendarOpen)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            )
          else
            Text(
              'Pekan ${getWeekOfYear(_selectedDate)}',
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  /// Builds the horizontal list of days for the selected week.
  Widget _buildWeekSelector() {
    final weekDays = getDaysInWeek(_selectedDate);
    const dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final activityProvider = Provider.of<ActivityProvider>(
      context,
      listen: false,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = weekDays[index];
        final isSelected =
            day.year == _selectedDate.year &&
            day.month == _selectedDate.month &&
            day.day == _selectedDate.day;

        // Check if there are activities for this day of the week (0-6)
        final hasActivity =
            activityProvider.getActivitiesForDay(index).isNotEmpty;

        return _buildDay(
          dayNames[index],
          '${day.day}',
          isSelected: isSelected,
          isWeekend: index > 4,
          onTap: () => _selectDate(day),
          hasActivity: hasActivity,
        );
      }),
    );
  }

  /// Builds a single day item for the week selector.
  Widget _buildDay(
    String dayName,
    String dayNum, {
    required bool isSelected,
    bool isWeekend = false,
    required VoidCallback onTap,
    bool hasActivity = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dayNum,
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : (isWeekend ? Colors.red : Colors.black),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              // Red dot indicator
              if (hasActivity)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.red,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 5), // Placeholder to keep alignment
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the full month calendar view.
  Widget _buildMonthCalendar() {
    final dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final firstDayOfMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month,
      1,
    );
    final daysToPad = firstDayOfMonth.weekday - 1;
    final firstDayOfCalendar = firstDayOfMonth.subtract(
      Duration(days: daysToPad),
    );

    final lastDayOfMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month + 1,
      0,
    );
    final totalDays = lastDayOfMonth.day + daysToPad;
    final rowCount = (totalDays / 7).ceil();

    List<Widget> calendarRows = [];
    for (int i = 0; i < rowCount; i++) {
      List<Widget> weekWidgets = [];
      DateTime weekStartDate = firstDayOfCalendar.add(Duration(days: i * 7));

      final selectedWeekStartDate = _selectedDate.subtract(
        Duration(days: _selectedDate.weekday - 1),
      );
      final isSelectedWeek =
          weekStartDate.year == selectedWeekStartDate.year &&
          weekStartDate.month == selectedWeekStartDate.month &&
          weekStartDate.day == selectedWeekStartDate.day;

      for (int j = 0; j < 7; j++) {
        final date = weekStartDate.add(Duration(days: j));
        final isCurrentMonth = date.month == _displayMonth.month;

        weekWidgets.add(
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(date),
              child: Container(
                color: Colors.transparent,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color:
                        isSelectedWeek
                            ? Colors.white
                            : !isCurrentMonth
                            ? Colors.grey.shade400
                            : date.weekday > 5
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      calendarRows.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration:
              isSelectedWeek
                  ? BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  )
                  : null,
          child: Row(children: weekWidgets),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                dayLabels
                    .map(
                      (label) => Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          Column(children: calendarRows),
        ],
      ),
    );
  }

  Widget _buildActivityList(List<Activity> activities) {
    final activityProvider = Provider.of<ActivityProvider>(
      context,
      listen: false,
    );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddActivityScreen(activity: activity),
              ),
            );
            if (result != null && result is Activity) {
              activityProvider.updateActivity(_selectedDayIndex, index, result);
              _showSuccessSnackbar("Anda berhasil mengubah aktivitas");
            } else if (result == 'delete') {
              _showDeleteConfirmation(index);
            }
          },
          child: Card(
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
                  child: Text(
                    activity.project,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activity.activityName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
        );
      },
    );
  }

  Widget _buildDailyHoursCard(int dailyHours) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jam Kerja Harian',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$dailyHours',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildNoActivityView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.watch_later_outlined,
              color: Colors.blue,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Aktivitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Isi aktivitas Anda sekarang.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(int weeklyHours) {
    return Container(
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
                const Text(
                  'Jam Kerja Mingguan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$weeklyHours/40',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: weeklyHours > 0 ? weeklyHours / 40 : 0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showDeleteConfirmation(int listIndex) {
    final activityProvider = Provider.of<ActivityProvider>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Hapus Aktivitas?'),
            content: const Text('Aktivitas ini akan dihapus.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tidak'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ya, Hapus'),
                onPressed: () {
                  Navigator.of(context).pop();
                  activityProvider.deleteActivity(_selectedDayIndex, listIndex);
                  _showSuccessSnackbar("Anda berhasil menghapus aktivitas");
                },
              ),
            ],
          ),
    );
  }
}
