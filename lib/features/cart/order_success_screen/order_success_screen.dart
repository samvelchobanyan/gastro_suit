import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/order.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Shows that [order] was placed, over the whole app, in place of the
/// sheet it was placed from (the route [context] belongs to).
void showOrderSuccess(BuildContext context, Order order) {
  Navigator.of(context, rootNavigator: true).pushReplacement(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => OrderSuccessScreen(order: order),
    ),
  );
}

/// The order was placed (handoff `PurchaseSuccess`): where and when to
/// collect it, and the way on to its status.
///
/// "Track order" leads to the Home tab, where the order's status is shown.
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final time = order.scheduledAt;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DSSpacing.base,
                    vertical: DSSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DSSpacing.base,
                          vertical: DSSpacing.xl,
                        ),
                        decoration: BoxDecoration(
                          color: colors.bgCanvas,
                          borderRadius: BorderRadius.circular(DSRadius.md),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/success_check.png',
                              width: DSSizes.successImage,
                              height: DSSizes.successImage,
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(height: DSSpacing.base),
                            Semantics(
                              header: true,
                              child: Text(
                                l10n.orderSuccessTitle,
                                textAlign: TextAlign.center,
                                style: DSTypography.h1.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DSSpacing.lg),
                      _Fact(
                        icon: PhosphorIcons.mapPin(),
                        label: l10n.orderSuccessBranch,
                        value: order.branchName,
                      ),
                      const SizedBox(height: DSSpacing.sm),
                      _Fact(
                        icon: PhosphorIcons.clock(),
                        label: l10n.orderSuccessTime,
                        value: time == null
                            ? l10n.cartTimeAsap
                            : DateFormat.Hm(
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(time),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DecoratedBox(
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
                child: DSButton(
                  label: l10n.orderTrack,
                  size: DSButtonSize.sm,
                  fullWidth: true,
                  onPressed: () {
                    // Closed first: going to a tab may take away the page
                    // this screen lies over.
                    final router = GoRouter.of(context);
                    Navigator.pop(context);
                    router.go(AppRoutes.home);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One thing to know about the order, on a dark tile: an icon, what it is
/// and its value.
class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(DSSpacing.base),
      decoration: BoxDecoration(
        color: colors.bgInverse,
        borderRadius: BorderRadius.circular(DSRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: DSSizes.iconMd, color: colors.textInverse),
          const SizedBox(width: DSSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: DSTypography.caption.copyWith(
                    // The quieter text on a dark fill.
                    color: colors.textInverse.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: DSSpacing.xxs),
                Text(
                  value,
                  style: DSTypography.bodyLgSemibold.copyWith(
                    color: colors.textInverse,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
