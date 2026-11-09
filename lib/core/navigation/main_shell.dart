import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/navigation/ds_bottom_navigation.dart';
import '../../l10n/generated/app_localizations.dart';

/// Hosts the active tab and the bottom navigation.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: DSBottomNavigation(
        currentIndex: shell.currentIndex,
        // Tapping the active tab again returns it to its root.
        onSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        items: [
          DSBottomNavigationItem(
            icon: PhosphorIcons.house(),
            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
            label: l10n.tabHome,
          ),
          DSBottomNavigationItem(
            icon: PhosphorIcons.coffee(),
            activeIcon: PhosphorIcons.coffee(PhosphorIconsStyle.fill),
            label: l10n.tabOrder,
          ),
          DSBottomNavigationItem(
            icon: PhosphorIcons.gift(),
            activeIcon: PhosphorIcons.gift(PhosphorIconsStyle.fill),
            label: l10n.tabGifts,
          ),
          DSBottomNavigationItem(
            icon: PhosphorIcons.user(),
            activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
