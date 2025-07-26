import 'package:desklab/domain/models/employee.dart';
import 'package:desklab/presentation/screen/employee/employee_detail_screen.dart';
import 'package:desklab/presentation/screen/home/activity/activity_detail_screen.dart';
import 'package:desklab/presentation/screen/main_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/activity-details',
      builder: (context, state) => const ActivityDetailScreen(),
    ),
    GoRoute(
      path: '/employee-details',
      builder: (context, state) {
        final employee =
            state.extra as Employee; // Safely cast the extra object
        return EmployeeDetailScreen(employee: employee);
      },
    ),
    // Add other routes here as your app grows
  ],
);
