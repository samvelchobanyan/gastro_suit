import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/navigation/ds_bottom_navigation.dart';
import '../../domain/state/server_config_state.dart';
import '../../features/auth/login_sheet/login_sheet.dart';
import '../../features/loyalty/loyalty_card_sheet/loyalty_card_sheet.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_status.dart';

/// Hosts the active tab and the bottom navigation, which floats over the
/// tab: a tab leaves room for it at the end of its scroll, the size of the
/// bottom padding it is given.
///
/// The navigation has one item that is not a tab: the loyalty card, opened
/// over whichever tab is shown. It is there when the instance has a loyalty
/// programme; a guest is asked to sign in instead.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loyalty =
        ref.watch(serverConfigProvider).value?.loyaltyEnabled ?? false;

    // Each item with the tab it shows; the loyalty card shows none.
    final items = <(DSBottomNavigationItem, int?)>[
      (
        DSBottomNavigationItem(
          icon: PhosphorIcons.house(),
          activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
          label: l10n.tabHome,
        ),
        0,
      ),
      (
        DSBottomNavigationItem(
          icon: PhosphorIcons.coffee(),
          activeIcon: PhosphorIcons.coffee(PhosphorIconsStyle.fill),
          label: l10n.tabOrder,
        ),
        1,
      ),
      if (loyalty)
        (
          DSBottomNavigationItem(
            icon: PhosphorIcons.qrCode(),
            activeIcon: PhosphorIcons.qrCode(PhosphorIconsStyle.fill),
            label: l10n.loyaltyShowCard,
          ),
          null,
        ),
      (
        DSBottomNavigationItem(
          icon: PhosphorIcons.gift(),
          activeIcon: PhosphorIcons.gift(PhosphorIconsStyle.fill),
          label: l10n.tabGifts,
        ),
        2,
      ),
      (
        DSBottomNavigationItem(
          icon: PhosphorIcons.user(),
          activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
          label: l10n.tabProfile,
        ),
        3,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: DSBottomNavigation(
        items: [for (final (item, _) in items) item],
        currentIndex: items.indexWhere((e) => e.$2 == shell.currentIndex),
        onSelected: (index) {
          final tab = items[index].$2;
          if (tab == null) {
            if (ref.read(authStatusProvider) == AuthStatus.signedIn) {
              showLoyaltyCard(context);
            } else {
              showLoginSheet(context);
            }
            return;
          }
          // Tapping the active tab again returns it to its root.
          shell.goBranch(tab, initialLocation: tab == shell.currentIndex);
        },
      ),
    );
  }
}
