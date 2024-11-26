import 'package:ent_insight_app/screens/guests/auth/login_screen.dart';
import 'package:ent_insight_app/screens/guests/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../widgets/dashboard/scaffold_widget.dart';

class GuestDashboardLayout extends StatefulWidget {
  const GuestDashboardLayout({super.key});

  @override
  State<GuestDashboardLayout> createState() => _GuestDashboardLayoutState();
}

class _GuestDashboardLayoutState extends State<GuestDashboardLayout> {
  List<PersistentTabConfig> _navBarItems(BuildContext buildContext) => [
        PersistentTabConfig(
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
          screen: const GuestHomeScreen(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            icon: const Icon(Icons.support_agent),
            title: ("Chat"),
          ),
          screen: Container(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            icon: const Icon(Icons.notifications),
            title: ("Notify"),
          ),
          screen: Container(),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: const Icon(Icons.login),
            title: ("LogIn"),
          ),
          onPressed: (context) {
            if (mounted) {
              pushScreenWithoutNavBar(
                context,
                const LoginScreen(),
              );
            }
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      navBarItems: _navBarItems,
    );
  }
}
