import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/price_format.dart';
import '../../../../design_system/components/feedback/ds_badge.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/order.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../shared_widgets/load_error_row.dart';
import '../../widgets/order_product_image.dart';
import '../order_history_controller.dart';
import '../../../shared_widgets/list_placeholder.dart';

/// The user's orders, newest first, a line between each two. The next page
/// is read when the list is scrolled to its end. A row opens its order.
class OrdersTab extends ConsumerWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final state = ref.watch(orderHistoryProvider);
    final history = state.value;

    if (history == null) {
      return state.hasError
          ? ListPlaceholder.failed(
              onRetry: () => ref.invalidate(orderHistoryProvider),
            )
          : const ListPlaceholder.loading();
    }
    final orders = history.orders;
    if (orders.isEmpty) {
      return ListPlaceholder.empty(emptyText: l10n.historyOrdersEmpty);
    }

    return RefreshIndicator(
      color: colors.brandPrimary,
      onRefresh: () async {
        try {
          final _ = await ref.refresh(orderHistoryProvider.future);
        } catch (_) {
          // The list stays; the spinner only needs to stop.
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          DSLayout.margin,
          0,
          DSLayout.margin,
          DSSpacing.base,
        ),
        itemCount: orders.length + (history.hasMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == orders.length) {
            final controller = ref.read(orderHistoryProvider.notifier);
            return history.moreFailed
                ? Padding(
                    padding: const EdgeInsets.only(top: DSSpacing.md),
                    child: LoadErrorRow(onRetry: controller.loadMore),
                  )
                : _NextPage(
                    // A new one for each page, so that each is asked for.
                    key: ValueKey(orders.length),
                    onShown: controller.loadMore,
                  );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (i > 0)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: DSSpacing.md),
                  height: DSSizes.borderWidthDefault,
                  color: colors.borderMuted,
                ),
              _OrderTile(order: orders[i]),
            ],
          );
        },
      ),
    );
  }
}

/// The end of the pages read so far: asks for the next one when the list
/// is scrolled to it.
class _NextPage extends StatefulWidget {
  const _NextPage({super.key, required this.onShown});

  final VoidCallback onShown;

  @override
  State<_NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<_NextPage> {
  @override
  void initState() {
    super.initState();
    // After the frame: reading the page changes the list being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onShown();
    });
  }

  @override
  Widget build(BuildContext context) => const Center(child: ListSpinner());
}

/// One order (handoff `ProductHistory`): the photo and the name of its
/// first product, with the count of the others on the photo; when it was
/// placed, its number and what it cost.
class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final first = order.lines.firstOrNull;
    final others = order.lines.length - 1;
    final placedAt = order.placedAt;
    final number = order.number;
    final quiet = DSTypography.bodySm.copyWith(color: colors.textTertiary);

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(AppRoutes.orderOf(order.id)),
        child: Row(
          children: [
            Stack(
              children: [
                OrderProductImage(url: first?.imageUrl),
                if (others > 0)
                  PositionedDirectional(
                    end: DSSpacing.xs,
                    bottom: DSSpacing.xs,
                    child: DSBadgeCounter(label: '+$others'),
                  ),
              ],
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    first?.choice.productName ?? order.branchName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySemibold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (placedAt != null) ...[
                    const SizedBox(height: DSSpacing.xxs),
                    Text(
                      DateFormat.yMMMd(locale).add_Hm().format(placedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: quiet,
                    ),
                  ],
                  if (number != null) ...[
                    const SizedBox(height: DSSpacing.xxs),
                    Text(
                      l10n.historyOrderNumber(number),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: quiet,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: DSSpacing.md),
            Text(
              formatPrice(context, order.total),
              style: DSTypography.body.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
