import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/auth/auth_status.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../design_system/components/feedback/ds_badge.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../design_system/theme/ds_status_bar.dart';
import '../../../domain/entities/branch.dart';
import '../../../domain/state/branches_state.dart';
import '../../../domain/state/menu_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../menu/menu_block/menu_block.dart';
import '../../menu/menu_block/menu_block_skeleton.dart';
import '../../shared_widgets/branch_hours_row.dart';
import '../../shared_widgets/load_error_row.dart';
import '../../shared_widgets/price_text.dart';
import '../branch_map_sheet/branch_map_sheet.dart';
import 'widgets/branch_header.dart';

/// One branch: its photo header, address and hours, and its menu, in one
/// scroll over the checkout bar. Opened from a branch list; covers the tab
/// bar. The header's photo runs under the status bar.
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

  /// Rating needs an account: a guest is sent to sign in and comes back to
  /// this screen. The feedback sheet is not built yet.
  void _rate(BuildContext context, WidgetRef ref) {
    if (ref.read(authStatusProvider) == AuthStatus.signedOut) {
      context.push(AppRoutes.login);
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

    final topInset = MediaQuery.paddingOf(context).top;

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
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(
                      branch: branch,
                      topInset: topInset,
                      surface: colors.bgSurface,
                      onBack: () => context.pop(),
                      onRate: () => _rate(context, ref),
                      onMap: BranchMapSheet.canShow(branch)
                          ? () => showBranchMap(context, branch)
                          : null,
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
      body = const SafeArea(bottom: false, child: _Loading());
    } else {
      // The list failed to load, or it no longer has this branch.
      body = SafeArea(
        bottom: false,
        child: _Failed(
          onBack: () => context.pop(),
          onRetry: () => ref.invalidate(branchesControllerProvider),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.bgSurface,
      // The top is left to the body: the header's photo goes under the
      // status bar.
      body: SafeArea(top: false, child: body),
    );
  }
}

/// The header as it scrolls away: it leaves with the page, and a strip of
/// the surface as high as the status bar stays in its place, so that the
/// menu's chips stop under the status bar and not behind it.
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate({
    required this.branch,
    required this.topInset,
    required this.surface,
    required this.onBack,
    required this.onRate,
    required this.onMap,
  });

  final Branch branch;
  final double topInset;
  final Color surface;
  final VoidCallback onBack;
  final VoidCallback onRate;
  final VoidCallback? onMap;

  @override
  double get maxExtent => BranchHeader.heightFor(topInset);

  @override
  double get minExtent => topInset;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // The status bar's icons are light over the photo and follow the
    // surface once the photo has left them.
    final overPhoto = shrinkOffset < maxExtent - topInset / 2;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overPhoto ? DSStatusBar.lightIcons : DSStatusBar.on(surface),
      child: ColoredBox(
        color: surface,
        child: ClipRect(
          child: Stack(
            children: [
              Positioned(
                top: -shrinkOffset,
                left: 0,
                right: 0,
                height: maxExtent,
                child: BranchHeader(
                  branch: branch,
                  topInset: topInset,
                  onBack: onBack,
                  onRate: onRate,
                  onMap: onMap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) =>
      oldDelegate.branch != branch ||
      oldDelegate.topInset != topInset ||
      oldDelegate.surface != surface;
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
