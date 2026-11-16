import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../design_system/components/buttons/ds_button.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/wallet_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../wallet/wallet_balance_sheet/wallet_balance_sheet.dart';
import '../../../wallet/wallet_top_up_sheet/wallet_top_up_sheet.dart';

/// Home's wallet (handoff `Wallet`): the balance and the way to top it up.
/// Opens what the balance is made of.
///
/// Takes no room for a guest, without a wallet, while it loads, or when it
/// fails to load.
class WalletBlock extends ConsumerWidget {
  const WalletBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider).value;
    if (wallet == null) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.base,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showWalletBalance(context),
        child: Container(
          padding: const EdgeInsets.all(DSSpacing.base),
          decoration: BoxDecoration(
            color: colors.bgInverse,
            borderRadius: BorderRadius.circular(DSRadius.lg),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(DSRadius.sm),
                child: Image.asset(
                  'assets/images/wallet.png',
                  width: DSSizes.walletImage,
                  height: DSSizes.walletImage,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.walletBalanceTitle,
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textInverse.withValues(
                          alpha: DSOpacity.quietOnDark,
                        ),
                      ),
                    ),
                    Text(
                      formatPrice(context, wallet.total),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.h1.copyWith(
                        color: colors.textInverse,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DSSpacing.md),
              DSButton(
                label: l10n.walletTopUp,
                icon: PhosphorIcons.plus(),
                size: DSButtonSize.xs,
                pill: true,
                onPressed: () => showWalletTopUp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
