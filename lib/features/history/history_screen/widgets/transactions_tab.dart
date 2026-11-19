import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/wallet_movement.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../wallet_movements_controller.dart';
import '../../../shared_widgets/list_placeholder.dart';

/// The money that moved, newest first. So far only what moved through the
/// wallet: the API lists nothing else.
class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(walletMovementsProvider);
    final movements = state.value;

    if (movements == null) {
      return state.hasError
          ? ListPlaceholder.failed(
              onRetry: () => ref.invalidate(walletMovementsProvider),
            )
          : const ListPlaceholder.loading();
    }
    if (movements.isEmpty) {
      return ListPlaceholder.empty(emptyText: l10n.historyTransactionsEmpty);
    }

    return RefreshIndicator(
      color: context.colors.brandPrimary,
      onRefresh: () async {
        try {
          final _ = await ref.refresh(walletMovementsProvider.future);
        } catch (_) {
          // The list stays; the spinner only needs to stop.
        }
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          DSLayout.margin,
          0,
          DSLayout.margin,
          DSSpacing.base,
        ),
        itemCount: movements.length,
        separatorBuilder: (_, _) => const SizedBox(height: DSSpacing.sm),
        itemBuilder: (context, i) => _MovementTile(movement: movements[i]),
      ),
    );
  }
}

/// One movement of money (handoff `Transactions`): what it was, when, and
/// how much, money that came in standing out.
class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement});

  final WalletMovement movement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final cameIn = movement.kind == WalletMovementKind.topUp;
    final amount = formatPrice(context, movement.amount);

    return Container(
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: colors.bgCanvas,
        borderRadius: BorderRadius.circular(DSRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: DSSizes.buttonHeightSm,
            height: DSSizes.buttonHeightSm,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.bgSurfaceSunken,
              borderRadius: BorderRadius.circular(DSRadius.sm),
            ),
            child: Icon(
              PhosphorIcons.wallet(),
              size: DSSizes.iconSm,
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
                  cameIn ? l10n.transactionTopUp : l10n.transactionSpend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySemibold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.xxs),
                Text(
                  DateFormat.yMMMd(locale).add_Hm().format(movement.at),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          Text(
            cameIn ? '+$amount' : '−$amount',
            style: DSTypography.bodySemibold.copyWith(
              color: cameIn ? colors.textSuccess : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
