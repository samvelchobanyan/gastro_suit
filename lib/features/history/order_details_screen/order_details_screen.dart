import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/utils/price_format.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/components/layout/ds_section_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/order.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/load_error_row.dart';
import '../widgets/order_product_image.dart';
import 'order_details_controller.dart';

/// One order in full: where it is, the branch, when and how it was paid,
/// what was ordered and what it cost. Opened from the history and from
/// Home's order status; covers the tab bar.
class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final state = ref.watch(orderProvider(orderId));
    final order = state.value;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(
              title: l10n.orderDetailsTitle,
              onBack: context.pop,
              backLabel: l10n.back,
            ),
            Expanded(
              child: order != null
                  ? RefreshIndicator(
                      color: colors.brandPrimary,
                      onRefresh: () async {
                        try {
                          final _ = await ref.refresh(
                            orderProvider(orderId).future,
                          );
                        } catch (_) {
                          // The order stays; the spinner only needs to stop.
                        }
                      },
                      child: _OrderDetails(order: order),
                    )
                  : state.hasError
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DSLayout.margin,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: LoadErrorRow(
                          onRetry: () => ref.invalidate(orderProvider(orderId)),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(DSSpacing.base),
                        child: SizedBox(
                          width: DSSizes.iconMd,
                          height: DSSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: DSSizes.borderWidthThick,
                            color: colors.brandPrimary,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.order});

  final Order order;

  static String _statusLabel(AppLocalizations l10n, OrderStatus status) =>
      switch (status) {
        OrderStatus.awaitingPayment => l10n.orderStatusAwaitingPayment,
        OrderStatus.placed => l10n.orderStepPlaced,
        OrderStatus.accepted => l10n.orderStepAccepted,
        OrderStatus.preparing => l10n.orderStepPreparing,
        OrderStatus.ready => l10n.orderStepReady,
        OrderStatus.collected => l10n.orderStatusCompleted,
        OrderStatus.cancelled => l10n.orderStatusCancelled,
        OrderStatus.paymentFailed => l10n.orderStatusPaymentFailed,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final number = order.number;
    final address = order.branchAddress;
    final placedAt = order.placedAt;
    final comment = order.comment;
    final onDark = DSTypography.body.copyWith(color: colors.textInverse);
    final label = DSTypography.body.copyWith(color: colors.textTertiary);
    final value = DSTypography.body.copyWith(color: colors.textPrimary);

    final details = <(String, String, Color?)>[
      if (placedAt != null)
        (
          l10n.orderDetailsDate,
          DateFormat.yMMMd(locale).add_Hm().format(placedAt),
          null,
        ),
      (l10n.orderDetailsFulfilment, l10n.orderDetailsPickup, null),
      (l10n.orderDetailsPaymentMethod, l10n.orderDetailsOnlinePayment, null),
      if (order.isPaid)
        (
          l10n.orderDetailsPaymentStatus,
          l10n.orderDetailsPaid,
          colors.textSuccess,
        ),
    ];
    final divider = Container(
      height: DSSizes.borderWidthDefault,
      color: colors.borderMuted,
    );
    const gap = SizedBox(height: DSSpacing.md);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.lg,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.base,
            vertical: DSSpacing.md,
          ),
          decoration: BoxDecoration(
            color: colors.bgInverse,
            borderRadius: BorderRadius.circular(DSRadius.md),
          ),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.forkKnife(),
                size: DSSizes.iconMd,
                color: colors.textInverse,
              ),
              const SizedBox(width: DSSpacing.sm),
              Expanded(
                child: Text(_statusLabel(l10n, order.status), style: onDark),
              ),
              if (number != null) ...[
                const SizedBox(width: DSSpacing.sm),
                Text(l10n.orderStatusNumber(number), style: onDark),
              ],
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.base),
        Row(
          children: [
            Container(
              width: DSSizes.buttonHeightMd,
              height: DSSizes.buttonHeightMd,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.bgCanvas,
                borderRadius: BorderRadius.circular(DSRadius.md),
              ),
              child: Icon(
                PhosphorIcons.mapPin(),
                size: DSSizes.iconMd,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.branchName,
                    style: DSTypography.bodySemibold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (address != null) ...[
                    const SizedBox(height: DSSpacing.xxs),
                    Text(
                      address,
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: DSSpacing.lg),
        for (final (i, (name, text, color)) in details.indexed) ...[
          if (i > 0) ...[gap, divider, gap],
          _AmountRow(
            label: name,
            value: text,
            labelStyle: label,
            valueStyle: color == null ? value : value.copyWith(color: color),
          ),
        ],
        if (comment != null) ...[
          gap,
          divider,
          gap,
          Text(l10n.orderDetailsComment, style: label),
          const SizedBox(height: DSSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DSSpacing.base,
              vertical: DSSpacing.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.borderMuted,
                width: DSSizes.borderWidthDefault,
              ),
              borderRadius: BorderRadius.circular(DSRadius.input),
            ),
            child: Text(
              comment,
              style: DSTypography.body.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
        const SizedBox(height: DSSpacing.lg),
        DSSectionHeader(title: l10n.orderDetailsYourOrder),
        for (final line in order.lines) ...[
          gap,
          _LineTile(branchId: order.branchId, line: line),
        ],
        gap,
        CustomPaint(
          size: const Size.fromHeight(DSSizes.borderWidthDefault),
          painter: _DashedLine(colors.borderDefault),
        ),
        gap,
        _AmountRow(
          label: l10n.orderDetailsSubtotal,
          value: formatPrice(context, order.subtotal),
          labelStyle: label,
          valueStyle: value,
        ),
        if (order.discount > 0) ...[
          gap,
          _AmountRow(
            label: l10n.orderDetailsDiscount,
            value: '−${formatPrice(context, order.discount)}',
            labelStyle: label,
            valueStyle: value,
          ),
        ],
        if (order.tip > 0) ...[
          gap,
          _AmountRow(
            label: l10n.cartSectionTip,
            value: formatPrice(context, order.tip),
            labelStyle: label,
            valueStyle: value,
          ),
        ],
        gap,
        _AmountRow(
          label: l10n.orderDetailsTotal,
          value: formatPrice(context, order.total),
          labelStyle: DSTypography.h2.copyWith(color: colors.textPrimary),
          valueStyle: DSTypography.h2.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}

/// A name at the start and its value at the end of one row.
class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(width: DSSpacing.base),
        Expanded(
          child: Text(value, textAlign: TextAlign.end, style: valueStyle),
        ),
      ],
    );
  }
}

/// One product of the order (handoff `ProductHorizontalCard`): its photo,
/// its name, what was chosen for it with the quantity, and what the line
/// cost.
class _LineTile extends StatelessWidget {
  const _LineTile({required this.branchId, required this.line});

  final String branchId;
  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final choice = line.choice;
    final info = [
      if (choice.size case final size?) size.name,
      for (final option in choice.options)
        option.quantity > 1
            ? '${option.name} ×${option.quantity}'
            : option.name,
      '×${line.quantity}',
    ].join(' · ');

    return Row(
      children: [
        OrderProductImage(branchId: branchId, productId: choice.productId),
        const SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                choice.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.bodySemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.xxs),
              Text(
                info,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.body.copyWith(color: colors.textTertiary),
              ),
              const SizedBox(height: DSSpacing.xxs),
              Text(
                formatPrice(context, line.total),
                style: DSTypography.bodySm.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The dashed line between the order's products and its amounts.
class _DashedLine extends CustomPainter {
  const _DashedLine(this.color);

  final Color color;

  /// The length of a dash, and of the gap after it.
  static const _dash = DSSpacing.xs;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;
    final y = size.height / 2;
    for (var x = 0.0; x < size.width; x += _dash * 2) {
      canvas.drawLine(Offset(x, y), Offset(x + _dash, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedLine old) => old.color != color;
}
