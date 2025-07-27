import 'package:desklab/domain/models/activity.dart';
import 'package:desklab/presentation/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_activity_screen.dart';
import 'report/report_screen.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key});
  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  bool _isCalendarOpen = false;
  late DateTime _selectedDate;
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarOpen = !_isCalendarOpen;
    });
  }

  void _changeMonth(int increment) {
    setState(() {
      _displayMonth = DateTime(
        _displayMonth.year,
        _displayMonth.month + increment,
      );
    });
  }

  void _selectDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _displayMonth = DateTime(newDate.year, newDate.month);
      _isCalendarOpen = false;
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
    });
  }

  int getWeekOfYear(DateTime date) {
    final dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

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

    final currentActivities = activityProvider.getActivitiesForDate(
      _selectedDate,
    );
    final int dailyHours = activityProvider.getTotalHoursForDate(_selectedDate);
    final int weeklyHours = activityProvider.getTotalHoursForWeek(
      _selectedDate,
    );
    // ADDED: Check if the selected day is a weekend.
    final bool isWeekend =
        _selectedDate.weekday == DateTime.saturday ||
        _selectedDate.weekday == DateTime.sunday;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
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
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                // CHANGED: Disable button on weekends.
                onPressed: isWeekend ? null : _showCopyActivityDialog,
                icon: const Icon(Icons.copy_all_outlined),
                label: const Text('Duplikat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.grey.shade200,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                // CHANGED: Disable button on weekends.
                onPressed:
                    isWeekend
                        ? null
                        : () async {
                          final result = await Navigator.push<Activity?>(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddActivityScreen(
                                    selectedDate: _selectedDate,
                                  ),
                            ),
                          );
                          if (result != null) {
                            activityProvider.addActivity(result);
                            _showSuccessSnackbar(
                              "Anda berhasil menambahkan aktivitas",
                            );
                          }
                        },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Aktivitas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.blue.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildWeeklyProgress(weeklyHours),
    );
  }

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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousWeek,
                ),
                Text(
                  'Pekan ${getWeekOfYear(_selectedDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextWeek,
                ),
              ],
            ),
        ],
      ),
    );
  }

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

        Color? dotColor;
        if (day.weekday >= 1 && day.weekday <= 5) {
          final totalHours = activityProvider.getTotalHoursForDate(day);
          if (totalHours >= 8) {
            dotColor = Colors.green;
          } else {
            dotColor = Colors.red;
          }
        }

        return _buildDay(
          dayNames[index],
          '${day.day}',
          isSelected: isSelected,
          isWeekend: day.weekday > 5,
          onTap: () => _selectDate(day),
          dotColor: dotColor,
        );
      }),
    );
  }

  Widget _buildDay(
    String dayName,
    String dayNum, {
    required bool isSelected,
    bool isWeekend = false,
    required VoidCallback onTap,
    Color? dotColor,
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
              if (dotColor != null)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : dotColor,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

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
                builder:
                    (context) => AddActivityScreen(
                      activity: activity,
                      selectedDate: _selectedDate,
                    ),
              ),
            );
            if (result != null && result is Activity) {
              activityProvider.updateActivity(activity.id, result);
              _showSuccessSnackbar("Anda berhasil mengubah aktivitas");
            } else if (result == 'delete') {
              _showDeleteConfirmation(activity.id);
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showDeleteConfirmation(String activityId) {
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
                  activityProvider.deleteActivity(activityId);
                  _showSuccessSnackbar("Anda berhasil menghapus aktivitas");
                },
              ),
            ],
          ),
    );
  }

  // ADDED: A helper widget for the custom radio button style.
  Widget _buildCopyOptionTile({
    required String title,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CHANGED: The entire dialog is redesigned to match the provided image.
  void _showCopyActivityDialog() {
    String? copyOption = 'last_workday'; // Default to 'Aktivitas terakhir'

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Center(
                child: Text(
                  'Duplikat dari',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCopyOptionTile(
                    title: 'Aktivitas terakhir',
                    value: 'last_workday',
                    groupValue: copyOption,
                    onChanged: (value) {
                      setState(() {
                        copyOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCopyOptionTile(
                    title: 'Aktivitas minggu lalu',
                    value: 'last_week',
                    groupValue: copyOption,
                    onChanged: (value) {
                      setState(() {
                        copyOption = value;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none, // Removes the outline
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Pilih'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (copyOption != null) {
                            _performCopyActivity(copyOption!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            );
          },
        );
      },
    );
  }

  // CHANGED: Logic updated to use findLastWorkday.
  void _performCopyActivity(String copyOption) {
    final provider = Provider.of<ActivityProvider>(context, listen: false);
    bool success;

    if (copyOption == 'last_week') {
      final sourceDate = _selectedDate.subtract(const Duration(days: 7));
      success = provider.copyActivities(from: sourceDate, to: _selectedDate);
      if (success) {
        _showSuccessSnackbar('Berhasil duplikat minggu lalu');
      } else {
        _showErrorSnackbar('Tidak ada aktivitas ditemukan di minggu lalu');
      }
    } else if (copyOption == 'last_workday') {
      final sourceDate = provider.findLastWorkday(_selectedDate);
      success = provider.copyActivities(from: sourceDate, to: _selectedDate);
      if (success) {
        _showSuccessSnackbar('Berhasil duplikat hari kerja terakhir');
      } else {
        _showErrorSnackbar('Aktivitas di hari kerja terakhir tidak ditemukan');
      }
    }
  }
}
