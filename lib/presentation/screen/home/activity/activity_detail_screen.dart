import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/activity.dart';
import '../../../providers/activity_provider.dart';
import 'add_activity_screen.dart';
import 'report/report_screen.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key});
  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  int _selectedDayIndex = 0;

  void _selectDay(int dayIndex) {
    setState(() {
      _selectedDayIndex = dayIndex;
    });
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildDateSelector(),
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
