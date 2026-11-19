import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../design_system/components/inputs/ds_segmented_tabs.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/orders_tab.dart';
import 'widgets/transactions_tab.dart';

enum _HistoryTab { orders, transactions }

/// What the user did so far, in two tabs: their orders, and the money that
/// moved. Opened from the profile; covers the tab bar.
///
/// Each tab loads, fails and refreshes on its own; this screen only switches
/// between them.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _tab = _HistoryTab.orders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.colors.bgSurface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(
              title: l10n.profileHistory,
              onBack: context.pop,
              backLabel: l10n.back,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DSLayout.margin,
                0,
                DSLayout.margin,
                DSSpacing.base,
              ),
              child: DSSegmentedTabs<_HistoryTab>(
                segments: [
                  DSSegment(
                    value: _HistoryTab.orders,
                    label: l10n.historyTabOrders,
                    icon: PhosphorIcons.receipt(),
                  ),
                  DSSegment(
                    value: _HistoryTab.transactions,
                    label: l10n.historyTabTransactions,
                    icon: PhosphorIcons.arrowsLeftRight(),
                  ),
                ],
                value: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
            ),
            Expanded(
              child: switch (_tab) {
                _HistoryTab.orders => const OrdersTab(),
                _HistoryTab.transactions => const TransactionsTab(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
