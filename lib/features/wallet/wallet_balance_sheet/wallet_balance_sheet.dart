import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/utils/price_format.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/wallet_state.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Opens what the wallet's balance is made of in a sheet.
Future<void> showWalletBalance(BuildContext context) => showDSBottomSheet<void>(
  context: context,
  title: AppLocalizations.of(context).walletBalanceTitle,
  child: const WalletBalanceSheet(),
);

/// What the wallet holds (handoff `WalletBalanceSheet`): all of it, what
/// the user topped up, what came as gifts, and what expires next.
///
/// The handoff lists every gift with its sender and its own date. The API
/// gives the gifts as one sum and one amount that expires next, so one row
/// stands in the list's place.
///
/// Topping up is not built yet: its button is shown and takes no taps.
class WalletBalanceSheet extends ConsumerWidget {
  const WalletBalanceSheet({super.key});

  /// A date this close is shown as urgent.
  static const expiresSoon = Duration(days: 7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final wallet = ref.watch(walletProvider).value;
    // Opened from a wallet on screen; gone only if the user signed out.
    if (wallet == null) return const SizedBox.shrink();

    final expiresAt = wallet.expiresAt;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(DSSpacing.base),
            decoration: BoxDecoration(
              color: colors.bgInverse,
              borderRadius: BorderRadius.circular(DSRadius.md),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.walletTotal,
                        style: DSTypography.bodySm.copyWith(
                          color: colors.textInverse.withValues(
                            alpha: DSOpacity.quietOnDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: DSSpacing.xxs),
                      Text(
                        formatPrice(context, wallet.total),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DSTypography.display.copyWith(
                          color: colors.textInverse,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DSSpacing.base),
                Image.asset(
                  'assets/images/wallet.png',
                  width: DSSizes.walletImageLg,
                  height: DSSizes.walletImageLg,
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: DSSpacing.lg),
          _Part(
            icon: PhosphorIcons.wallet(),
            title: l10n.walletOwnTopUp,
            titleStyle: DSTypography.bodySemibold,
            note: l10n.walletNoExpiry,
            amount: wallet.ownTopUp,
          ),
          if (wallet.gifts > 0) ...[
            const SizedBox(height: DSSpacing.md),
            Divider(
              height: DSSizes.borderWidthDefault,
              thickness: DSSizes.borderWidthDefault,
              color: colors.borderMuted,
            ),
            const SizedBox(height: DSSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    l10n.walletGifts,
                    style: DSTypography.bodySemibold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  l10n.walletGiftsTotal(formatPrice(context, wallet.gifts)),
                  style: DSTypography.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
          if (expiresAt != null) ...[
            const SizedBox(height: DSSpacing.md),
            _Part(
              icon: PhosphorIcons.gift(),
              title: l10n.walletExpiring,
              titleStyle: DSTypography.body,
              note: l10n.walletExpires(
                DateFormat.yMMMd(locale).format(expiresAt),
              ),
              urgent: expiresAt.difference(DateTime.now()) <= expiresSoon,
              amount: wallet.expiring,
            ),
          ],
          const SizedBox(height: DSSpacing.lg),
          // TODO: topping up the wallet.
          DSButton(
            label: l10n.walletTopUp,
            size: DSButtonSize.sm,
            fullWidth: true,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

/// One part of the balance: an icon, what it is, a note under it and its
/// amount.
class _Part extends StatelessWidget {
  const _Part({
    required this.icon,
    required this.title,
    required this.titleStyle,
    required this.note,
    required this.amount,
    this.urgent = false,
  });

  final IconData icon;
  final String title;
  final TextStyle titleStyle;
  final String note;
  final int amount;

  /// The note is a date that is close.
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: DSSizes.buttonHeightSm,
          height: DSSizes.buttonHeightSm,
          decoration: BoxDecoration(
            color: colors.bgCanvas,
            borderRadius: BorderRadius.circular(DSRadius.md),
          ),
          child: Icon(icon, size: DSSizes.iconMd, color: colors.textPrimary),
        ),
        const SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: DSSpacing.xxs),
              Text(
                note,
                style: DSTypography.bodySm.copyWith(
                  color: urgent ? colors.textError : colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: DSSpacing.md),
        Text(
          formatPrice(context, amount),
          style: DSTypography.bodySemibold.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
