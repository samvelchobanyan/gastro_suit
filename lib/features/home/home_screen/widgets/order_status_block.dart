import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/state/active_orders_state.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Home's status of the orders on their way, one card an order, newest
/// first. Takes no room when there is none, while they load, or when they
/// fail to load: Home works without it.
class OrderStatusBlock extends ConsumerWidget {
  const OrderStatusBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(activeOrdersProvider).value ?? const [];
    if (orders.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final order in orders)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.base),
              child: _OrderCard(order: order),
            ),
        ],
      ),
    );
  }
}

/// One order: how it is collected, its number and the steps it goes through.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final time = order.scheduledAt;
    final number = order.number;
    final current = ActiveOrdersController.steps.indexOf(order.status);

    return Container(
      padding: const EdgeInsets.all(DSSpacing.base),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(
          color: colors.borderMuted,
          width: DSSizes.borderWidthDefault,
        ),
        borderRadius: BorderRadius.circular(DSRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: DSSizes.buttonHeightMd,
                height: DSSizes.buttonHeightMd,
                decoration: BoxDecoration(
                  color: colors.brandPrimary,
                  borderRadius: BorderRadius.circular(DSRadius.md),
                ),
                child: Icon(
                  PhosphorIcons.coffee(),
                  size: DSSizes.iconMd,
                  color: colors.textOnBrand,
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.orderStatusTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.h3.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DSSpacing.xxs),
                    Text(
                      l10n.orderStatusPickup(
                        time == null
                            ? l10n.cartTimeAsap
                            : DateFormat.Hm(
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(time),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (number != null) ...[
                const SizedBox(width: DSSpacing.sm),
                Text(
                  l10n.orderStatusNumber(number),
                  style: DSTypography.bodySemibold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: DSSpacing.base),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, step) in ActiveOrdersController.steps.indexed) ...[
                if (i > 0) const SizedBox(width: DSSpacing.xs),
                Expanded(
                  child: _Step(
                    status: step,
                    done: i < current,
                    active: i == current,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// One step of an order: a bar, an icon and a name. The step the order is
/// at is accented, the ones behind it are dimmed, the ones ahead are quiet.
class _Step extends StatelessWidget {
  const _Step({required this.status, required this.done, required this.active});

  final OrderStatus status;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final (icon, label) = switch (status) {
      OrderStatus.accepted => (
        PhosphorIcons.thumbsUp(),
        l10n.orderStepAccepted,
      ),
      OrderStatus.preparing => (
        PhosphorIcons.cookingPot(),
        l10n.orderStepPreparing,
      ),
      OrderStatus.ready => (PhosphorIcons.checkCircle(), l10n.orderStepReady),
      _ => (PhosphorIcons.receipt(), l10n.orderStepPlaced),
    };
    final color = active
        ? colors.textAccent
        : done
        ? colors.textPrimary
        : colors.textTertiary;

    return Semantics(
      selected: active,
      child: Opacity(
        opacity: done ? DSOpacity.disabled : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: DSSizes.stepBarHeight,
              decoration: BoxDecoration(
                color: active
                    ? colors.brandPrimary
                    : done
                    ? colors.textPrimary
                    : colors.borderMuted,
                borderRadius: BorderRadius.circular(DSRadius.full),
              ),
            ),
            const SizedBox(height: DSSpacing.sm),
            Icon(icon, size: DSSizes.iconSm, color: color),
            const SizedBox(height: DSSpacing.xxs),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: DSTypography.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
