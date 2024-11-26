import 'package:ent_insight_app/screens/guests/auth/login_screen.dart';
import 'package:ent_insight_app/screens/guests/layouts/dashboard_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RouteName {
  static const String login = '/login';
  static const String guestDashboard = '/guest/dashboard';
  static const String adminDashboard = '/admin/dashboard';
  static const String doctorDashboard = '/doctor/dashboard';
  static const String radiologistDashboard = '/radiologist/dashboard';
  static const String studentDashboard = '/student/dashboard';
}

Map<String, Widget Function(BuildContext)> routes = {
  RouteName.login: (context) => const LoginScreen(),
  RouteName.guestDashboard: (context) => const GuestDashboardLayout(),
  // RouteName.adminDashboard: (context) => const GuestDashboardLayout(),
  // RouteName.doctorDashboard: (context) => const GuestDashboardLayout(),
  // RouteName.radiologistDashboard: (context) => const GuestDashboardLayout(),
  // RouteName.studentDashboard: (context) => const GuestDashboardLayout(),
};

final PersistentTabController persistentTabController = PersistentTabController(initialIndex: 0);
