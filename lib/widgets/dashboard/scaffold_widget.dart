import 'package:ent_insight_app/routes/app_routes.dart';
import 'package:ent_insight_app/utils/theme_consts.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({super.key, required this.navBarItems});

  final List<PersistentTabConfig> Function(BuildContext buildContext) navBarItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ThemeConsts.appPrimaryColorLight,
        body: PersistentTabView(
          controller: persistentTabController,
          tabs: navBarItems(context),
          navBarBuilder: (navBarConfig) => Style2BottomNavBar(
            navBarConfig: navBarConfig,
          ),
        ),
      ),
    );
  }
}
