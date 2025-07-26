import 'package:desklab/domain/models/activity.dart';
import 'package:desklab/domain/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// --- Main App ---

void main() {
  runApp(const DeskLabApp());
}

class DeskLabApp extends StatelessWidget {
  const DeskLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeskLab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF555555)),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- Main Screen with Navigation ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    EmployeeListScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to keep state of each screen
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Karyawan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- Home Screen (Beranda) ---

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
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ActivityDetailScreen(),
            ),
          ),
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

// --- Activity Detail Screen ---
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

// --- Add/Edit Activity Screen ---
class AddActivityScreen extends StatefulWidget {
  final Activity? activity;
  const AddActivityScreen({super.key, this.activity});
  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectController,
      _activityController,
      _hoursController,
      _notesController;
  bool get isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    _projectController = TextEditingController(text: widget.activity?.project);
    _activityController = TextEditingController(
      text: widget.activity?.activityName,
    );
    _hoursController = TextEditingController(
      text: widget.activity?.hours.toString(),
    );
    _notesController = TextEditingController(text: widget.activity?.notes);
  }

  @override
  void dispose() {
    _projectController.dispose();
    _activityController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Mohon Tunggu"),
              ],
            ),
          ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      Timer(const Duration(seconds: 1), () {
        final newActivity = Activity(
          project: _projectController.text,
          activityName: _activityController.text,
          hours: int.parse(_hoursController.text),
          notes: _notesController.text,
          color:
              isEditing
                  ? widget.activity!.color
                  : (_projectController.text.contains("DEV")
                      ? const Color(0xFF4A6572)
                      : Colors.brown),
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop(newActivity);
      });
    }
  }

  void _selectProject() async {
    final result = await _showSelectionScreen(
      context: context,
      title: 'Daftar Proyek',
      items: [
        'KLIK-CORP-KLIK-DEVELOPMENT',
        'EDTS-ADMIN-ADMIN-TRAINING',
        'GURIH-CORP-GURIHMART-DEV',
      ],
    );
    if (result != null) _projectController.text = result;
  }

  void _selectActivity() async {
    final result = await _showSelectionScreen(
      context: context,
      title: 'Daftar Aktivitas',
      items: [
        'Development',
        'Sharing Session',
        'Research / Planning',
        'Bugs Fixing',
      ],
    );
    if (result != null) _activityController.text = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Ubah Aktivitas' : 'Tambah Aktivitas',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (isEditing)
            TextButton(
              onPressed: () => Navigator.of(context).pop('delete'),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextField(
              label: 'Tanggal',
              initialValue: '21 Juli 2025',
              readOnly: true,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Proyek',
              controller: _projectController,
              onTap: _selectProject,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Aktivitas',
              controller: _activityController,
              onTap: _selectActivity,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Jam Kerja',
              controller: _hoursController,
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Catatan',
              controller: _notesController,
              maxLines: 3,
              hint: 'Masukkan Catatan (Opsional)',
            ),
            const SizedBox(height: 16),
            _buildAttachmentField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(isEditing ? 'Simpan' : 'Tambah'),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? icon,
    int? maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${validator != null ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: 'Cari atau Pilih $label',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lampiran', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(Icons.upload_file, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text('Upload Lampiran'),
                Text(
                  'file didukung: .pdf, .zip, .jpg, .jpeg, .png. Maksimum 5MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showSelectionScreen({
    required BuildContext context,
    required String title,
    required List<String> items,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder:
                (_, scrollController) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari $title',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder:
                            (context, index) => ListTile(
                              title: Text(items[index]),
                              onTap:
                                  () => Navigator.of(context).pop(items[index]),
                            ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}

// --- Employee Screens ---

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _searchController = TextEditingController();
  late Map<String, List<Employee>> _allEmployees;
  Map<String, List<Employee>> _filteredEmployees = {};

  @override
  void initState() {
    super.initState();
    _allEmployees = {
      'Mobile Engineering': [
        Employee(
          name: 'Abraham Wong',
          title: 'Mobile Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=AW',
          phone: '081234567890',
          email: 'abraham.wong@sg-edts.com',
          employeeId: 'EDTS022189',
          department: 'Product Development & Operation',
          division: 'Mobile Engineering',
          joinDate: '10 Jan 2023',
        ),
        Employee(
          name: 'Hafshy Yazid Albisthami',
          title: 'Associate Mobile Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=HY',
          phone: '085795395767',
          email: 'hafshy.yazid@sg-edts.com',
          employeeId: 'EDTS90247',
          department: 'Product Development & Operation',
          division: 'Mobile Engineering',
          joinDate: '8 Januari 2024',
        ),
      ],
      'Data Science & Analytics': [
        Employee(
          name: 'Shafa Az Zahra',
          title: 'Data Analyst Associate',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=SZ',
          phone: '081234567892',
          email: 'shafa.zahra@sg-edts.com',
          employeeId: 'EDTS022191',
          department: 'Data',
          division: 'Data Science & Analytics',
          joinDate: '12 Mar 2023',
        ),
      ],
      'Frontend Engineering': [
        Employee(
          name: 'Mohammad Hafidh Wildan M',
          title: 'Associate Frontend Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=MW',
          phone: '081234567893',
          email: 'hafidh.wildan@sg-edts.com',
          employeeId: 'EDTS022192',
          department: 'Product Development & Operation',
          division: 'Frontend Engineering',
          joinDate: '15 Apr 2023',
        ),
      ],
    };
    _filteredEmployees = _allEmployees;
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = _allEmployees;
      } else {
        _filteredEmployees = {};
        _allEmployees.forEach((department, employees) {
          final filteredList =
              employees
                  .where(
                    (employee) => employee.name.toLowerCase().contains(query),
                  )
                  .toList();
          if (filteredList.isNotEmpty) {
            _filteredEmployees[department] = filteredList;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Karyawan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Karyawan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredEmployees.keys.length,
        itemBuilder: (context, index) {
          final department = _filteredEmployees.keys.elementAt(index);
          final employeeList = _filteredEmployees[department]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  department,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employeeList.length,
                itemBuilder: (context, empIndex) {
                  final employee = employeeList[empIndex];
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EmployeeDetailScreen(employee: employee),
                          ),
                        ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(employee.imageUrl),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                employee.title,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Karyawan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(employee.imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            employee.title,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildProfileDetailRow(Icons.phone, 'Telepon', employee.phone),
                _buildProfileDetailRow(Icons.email, 'Email', employee.email),
                _buildProfileDetailRow(
                  Icons.badge,
                  'ID Karyawan',
                  employee.employeeId,
                ),
                _buildProfileDetailRow(
                  Icons.business,
                  'Departemen',
                  employee.department,
                ),
                _buildProfileDetailRow(
                  Icons.group_work,
                  'Divisi',
                  employee.division,
                ),
                _buildProfileDetailRow(
                  Icons.calendar_today,
                  'Tanggal Bergabung',
                  employee.joinDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Other Screens (Notifications, Profile, etc.) ---

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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://placehold.co/100x100/EFEFEF/333333?text=RF',
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ridhan Fadhilah',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mobile Engineer',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildProfileDetailRow(Icons.phone, 'Telepon', '081220220697'),
                _buildProfileDetailRow(
                  Icons.email,
                  'Email',
                  'ridhan.fadhilah@sg-edts.com',
                ),
                _buildProfileDetailRow(Icons.badge, 'ID Karyawan', 'EDTS90122'),
                _buildProfileDetailRow(
                  Icons.business,
                  'Departemen',
                  'Product Development & Operation',
                ),
                _buildProfileDetailRow(
                  Icons.group_work,
                  'Divisi',
                  'Mobile Engineering',
                ),
                _buildProfileDetailRow(
                  Icons.calendar_today,
                  'Tanggal Bergabung',
                  '5 April 2021',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aset',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildProfileDetailRow(
                  Icons.laptop_mac,
                  'Macbook Pro Touch Bar 13',
                  'EDTS022188',
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_to_queue),
                  label: const Text('Daftarkan Aset'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuti',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Saldo Cuti',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLeaveBalanceCard(
                'Cuti Tahun ini',
                '1.5 hari',
                'Kadaluwarsa: 01/08/2026',
              ),
              const SizedBox(width: 16),
              _buildLeaveBalanceCard(
                'Cuti Tahun Sebelumnya',
                '0 hari',
                'Kadaluwarsa: 01/08/2025',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Riwayat Cuti',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHistoryTile('23 Jul 2025', 'Cuti Tahunan'),
          _buildHistoryTile('10 Jul 2025', 'Cuti Tahunan'),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Ajukan Cuti'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceCard(String title, String days, String expiry) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              days,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              expiry,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialWorkScreen extends StatelessWidget {
  const SpecialWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kerja Khusus',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Riwayat Kerja Khusus',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHistoryTile('04 Jul 2025', 'Izin Khusus', approved: true),
          _buildHistoryTile('07 Mei 2025', 'Izin Khusus', approved: true),
          _buildHistoryTile('06 Mei 2025', 'Izin Khusus', approved: false),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Ajukan Kerja Khusus'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Laporan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          leading: const BackButton(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: 'Mingguan'), Tab(text: 'Bulanan')],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportTabView(isWeekly: true),
            ReportTabView(isWeekly: false),
          ],
        ),
      ),
    );
  }
}

class ReportTabView extends StatelessWidget {
  final bool isWeekly;
  const ReportTabView({super.key, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    final totalHours = isWeekly ? 9 : 13;
    final maxHours = isWeekly ? 40 : 184;
    final activities = [
      Activity(
        project: 'EDTS-ADMIN-ADMIN-LEAVE',
        activityName: 'Annual Leave',
        hours: 4,
        color: Colors.purple,
      ),
      Activity(
        project: 'EDTS-ADMIN-ADMIN-TRAINING',
        activityName: 'Sharing Session',
        hours: 5,
        color: Colors.brown,
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Dropdowns for date range would go here
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

// --- Helper Widgets and Models ---

Widget _buildHistoryTile(String date, String title, {bool approved = true}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          approved ? Icons.check_circle : Icons.cancel,
          color: approved ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    ),
  );
}

Widget _buildProfileDetailRow(IconData icon, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}

class CalendarEvent {
  final String day;
  final String month;
  final String name;
  final String type;
  final Color color;

  CalendarEvent(this.day, this.month, this.name, this.type, this.color);
}
