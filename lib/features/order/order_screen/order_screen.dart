import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../design_system/components/inputs/ds_segmented_tabs.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../branches/branch_list_block/branch_list_block.dart';

enum _OrderTab { products, branches }

/// The Order tab: the menu of the active branch and the list of branches,
/// switched by the tabs under the title. Each view scrolls on its own and
/// keeps its place while the other is shown.
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _tab = _OrderTab.products;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: context.colors.bgSurface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(title: l10n.tabOrder),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DSLayout.margin,
                0,
                DSLayout.margin,
                DSSpacing.base,
              ),
              child: DSSegmentedTabs<_OrderTab>(
                segments: [
                  DSSegment(
                    value: _OrderTab.products,
                    label: l10n.orderTabProducts,
                    icon: PhosphorIcons.coffee(),
                  ),
                  DSSegment(
                    value: _OrderTab.branches,
                    label: l10n.orderTabBranches,
                    icon: PhosphorIcons.storefront(),
                  ),
                ],
                value: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tab.index,
                children: const [_ProductsPlaceholder(), BranchListBlock()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stands in until the menu is built.
class _ProductsPlaceholder extends StatelessWidget {
  const _ProductsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).orderTabProducts,
        style: DSTypography.body.copyWith(color: context.colors.textTertiary),
      ),
    );
  }
}
