import 'package:desklab/domain/models/activity.dart';
import 'package:desklab/presentation/screen/home/activity/add_activity_screen.dart';
import 'package:desklab/presentation/screen/home/activity/report/report_screen.dart';
import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key});
  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late Map<int, List<Activity>> _activitiesByDay;
  int _selectedDayIndex = 0; // 0 for Monday, 6 for Sunday
  int _dailyHours = 0;
  int _weeklyHours = 0;

  @override
  void initState() {
    super.initState();
    // Initial data based on screenshots
    _activitiesByDay = {
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
    _calculateHours();
  }

  void _calculateHours() {
    int daily = 0;
    int weekly = 0;

    // Calculate daily hours for the selected day
    final activitiesForSelectedDay = _activitiesByDay[_selectedDayIndex] ?? [];
    for (var activity in activitiesForSelectedDay) {
      daily += activity.hours;
    }

    // Calculate total weekly hours
    _activitiesByDay.forEach((day, activities) {
      for (var activity in activities) {
        weekly += activity.hours;
      }
    });

    setState(() {
      _dailyHours = daily;
      _weeklyHours = weekly;
    });
  }

  void _addActivity(Activity activity) {
    setState(() {
      // Add activity to the selected day
      if (_activitiesByDay.containsKey(_selectedDayIndex)) {
        _activitiesByDay[_selectedDayIndex]!.add(activity);
      } else {
        _activitiesByDay[_selectedDayIndex] = [activity];
      }
      _calculateHours();
    });
    _showSuccessSnackbar("Anda berhasil menambahkan aktivitas");
  }

  void _updateActivity(int listIndex, Activity activity) {
    setState(() {
      _activitiesByDay[_selectedDayIndex]![listIndex] = activity;
      _calculateHours();
    });
    _showSuccessSnackbar("Anda berhasil mengubah aktivitas");
  }

  void _deleteActivity(int listIndex) {
    setState(() {
      _activitiesByDay[_selectedDayIndex]!.removeAt(listIndex);
      if (_activitiesByDay[_selectedDayIndex]!.isEmpty) {
        _activitiesByDay.remove(_selectedDayIndex);
      }
      _calculateHours();
    });
    _showSuccessSnackbar("Anda berhasil menghapus aktivitas");
  }

  void _showDeleteConfirmation(int listIndex) {
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
                child: const Text('Ya, Hapus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteActivity(listIndex);
                },
              ),
            ],
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

  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityScreen()),
    );
    if (result != null && result is Activity) _addActivity(result);
  }

  void _navigateToEditScreen(int listIndex) async {
    final activityToEdit = _activitiesByDay[_selectedDayIndex]![listIndex];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(activity: activityToEdit),
      ),
    );
    if (result != null && result is Activity) {
      _updateActivity(listIndex, result);
    } else if (result == 'delete') {
      _showDeleteConfirmation(listIndex);
    }
  }

  void _selectDay(int dayIndex) {
    setState(() {
      _selectedDayIndex = dayIndex;
      _calculateHours();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentActivities = _activitiesByDay[_selectedDayIndex] ?? [];

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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildDateSelector(),
                const SizedBox(height: 24),
                _buildDailyHoursCard(),
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
          onPressed: _navigateToAddScreen,
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
      bottomSheet: _buildWeeklyProgress(),
    );
  }

  Widget _buildActivityList(List<Activity> activities) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return GestureDetector(
          onTap: () => _navigateToEditScreen(index),
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

  Widget _buildDateSelector() {
    const dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final dayNumbers = ['21', '22', '23', '24', '25', '26', '27'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Juli 2025',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
            const Text('Pekan 30', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            return _buildDay(
              dayNames[index],
              dayNumbers[index],
              isSelected: _selectedDayIndex == index,
              isWeekend: index > 4,
              onTap: () => _selectDay(index),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDay(
    String dayName,
    String dayNum, {
    required bool isSelected,
    bool isWeekend = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              dayName,
              style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _buildDailyHoursCard() {
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
            '$_dailyHours',
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

  Widget _buildWeeklyProgress() {
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
                  '$_weeklyHours/40',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _weeklyHours > 0 ? _weeklyHours / 40 : 0,
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
}
