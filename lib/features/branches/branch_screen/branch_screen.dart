import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../design_system/components/feedback/ds_badge.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/branch.dart';
import '../../../domain/state/branches_state.dart';
import '../../../domain/state/menu_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../menu/menu_block/menu_block.dart';
import '../../menu/menu_block/menu_block_skeleton.dart';
import '../../shared_widgets/branch_hours_row.dart';
import '../../shared_widgets/load_error_row.dart';
import '../../shared_widgets/price_text.dart';
import 'widgets/branch_header.dart';

/// One branch: its photo header, address and hours, and its menu, in one
/// scroll over the checkout bar. Opened from a branch list; covers the tab
/// bar.
///
/// Takes the branch out of the loaded branch list by its id.
class BranchScreen extends ConsumerWidget {
  const BranchScreen({super.key, required this.branchId});

  final String branchId;

  /// The branch and its menu already on screen stay until the new ones
  /// arrive; a failed refresh keeps them.
  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(menuProvider(branchId));
    ref.invalidate(branchesControllerProvider);
    try {
      await Future.wait<Object>([
        ref.read(menuProvider(branchId).future),
        ref.read(branchesControllerProvider.future),
      ]);
    } catch (_) {
      // The menu block shows its own outcome; the spinner only needs to stop.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(branchesControllerProvider);
    final branches = state.value;
    final branch = branches
        ?.where((item) => item.branch.id == branchId)
        .firstOrNull
        ?.branch;

    final Widget body;
    if (branch != null) {
      body = Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: colors.brandPrimary,
              onRefresh: () => _refresh(ref),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: BranchHeader(
                      branch: branch,
                      onBack: () => context.pop(),
                      // The feedback and map sheets are not built yet.
                      onRate: () {},
                      onMap: () {},
                    ),
                  ),
                  SliverToBoxAdapter(child: _Info(branch: branch)),
                  MenuBlock(branchId: branchId),
                ],
              ),
            ),
          ),
          const _CheckoutBar(),
        ],
      );
    } else if (branches == null && !state.hasError) {
      body = const _Loading();
    } else {
      // The list failed to load, or it no longer has this branch.
      body = _Failed(
        onBack: () => context.pop(),
        onRetry: () => ref.invalidate(branchesControllerProvider),
      );
    }

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(child: body),
    );
  }
}

/// The address, and today's hours with the open / closed pill.
class _Info extends StatelessWidget {
  const _Info({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.mapPin(),
                size: DSSizes.iconXs,
                color: colors.textTertiary,
              ),
              const SizedBox(width: DSSpacing.xs),
              Expanded(
                child: Text(
                  branch.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySm.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (BranchHoursRow.hasContentFor(branch))
            Padding(
              padding: const EdgeInsets.only(top: DSSpacing.xs),
              child: BranchHoursRow(branch: branch),
            ),
        ],
      ),
    );
  }
}

/// The button that opens the cart, with the cart's total and the number of
/// items in it. The cart is not built yet: it shows an empty one and does
/// nothing.
class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(
          top: BorderSide(
            color: colors.borderMuted,
            width: DSSizes.borderWidthDefault,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.base),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            DSButton(
              label: AppLocalizations.of(
                context,
              ).checkoutWithTotal(formatPrice(context, 0)),
              icon: PhosphorIcons.shoppingCartSimple(),
              variant: DSButtonVariant.secondary,
              size: DSButtonSize.sm,
              fullWidth: true,
              onPressed: () {},
            ),
            // Over the button's end; taps go through to the button.
            const IgnorePointer(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: DSSpacing.base),
                child: DSBadge(count: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// While the branch list loads: a way back and the menu's placeholder.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackRow(onBack: () => context.pop()),
          const MenuBlockSkeleton(),
        ],
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onBack, required this.onRetry});

  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackRow(onBack: onBack),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          child: LoadErrorRow(onRetry: onRetry),
        ),
      ],
    );
  }
}

/// The back button where the header has it, for the states without one.
class _BackRow extends StatelessWidget {
  const _BackRow({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DSSpacing.md),
      child: DSIconButton(
        icon: PhosphorIcons.arrowLeft(),
        semanticLabel: AppLocalizations.of(context).back,
        variant: DSIconButtonVariant.tonal,
        size: DSIconButtonSize.xs,
        onPressed: onBack,
      ),
    );
  }
}
