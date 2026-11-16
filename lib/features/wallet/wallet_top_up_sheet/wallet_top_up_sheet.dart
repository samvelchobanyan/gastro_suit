import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/di/repositories.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/utils/price_format.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_amount_field.dart';
import '../../../design_system/components/inputs/ds_payment_method.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/payment_cards_state.dart';
import '../../../domain/state/server_config_state.dart';
import '../../../domain/state/wallet_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../payment/payment_method_sheet/payment_method_sheet.dart';
import '../wallet_top_up_success_screen/wallet_top_up_success_screen.dart';

/// Opens topping up the wallet in a sheet.
Future<void> showWalletTopUp(BuildContext context) => showDSBottomSheet<void>(
  context: context,
  title: AppLocalizations.of(context).walletTopUpTitle,
  child: const WalletTopUpSheet(),
);

/// Topping up the wallet (handoff `WalletTopupBottomSheet`): the card, the
/// amount and the button. The amount is within the instance's limits.
///
/// Built for a payment gateway that needs no page: the top-up comes back
/// done. One that sends the bank's page is answered with a message; that
/// page is not opened yet. The card is shown as drawn, but the API takes no
/// card with a top-up, so choosing one changes nothing yet.
class WalletTopUpSheet extends ConsumerStatefulWidget {
  const WalletTopUpSheet({super.key});

  @override
  ConsumerState<WalletTopUpSheet> createState() => _WalletTopUpSheetState();
}

class _WalletTopUpSheetState extends ConsumerState<WalletTopUpSheet> {
  final _amountController = TextEditingController();
  int? _amount;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _topUp(int amount) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final done = await ref.read(walletRepositoryProvider).topUp(amount);
      if (!mounted) return;
      if (!done) {
        setState(() {
          _busy = false;
          _error = l10n.walletTopUpUnavailable;
        });
        return;
      }
      ref.invalidate(walletProvider);
      showWalletTopUpSuccess(context, amount);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = errorText(context, error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(serverConfigProvider).value;
    final min = config?.minTopUp;
    final max = config?.maxTopUp;
    final card = ref.watch(paymentCardProvider);
    final amount = _amount;
    final allowed =
        amount != null &&
        amount > 0 &&
        (min == null || amount >= min) &&
        (max == null || amount <= max);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DSPaymentMethod(
            icon: PhosphorIcons.creditCard(),
            name: card == null
                ? l10n.paymentNewCard
                : l10n.paymentCard(card.lastDigits),
            showCaret: true,
            onTap: () => showPaymentMethods(context),
          ),
          const SizedBox(height: DSSpacing.base),
          DSAmountField(
            controller: _amountController,
            hintText: l10n.walletTopUpAmountHint,
            suffix: currencySign,
            maxDigits: 7,
            onChanged: (value) => setState(() {
              _amount = value;
              _error = null;
            }),
          ),
          if (min != null && max != null) ...[
            const SizedBox(height: DSSpacing.xs),
            Text(
              l10n.walletTopUpLimits(
                formatPrice(context, min),
                formatPrice(context, max),
              ),
              style: DSTypography.bodySm.copyWith(color: colors.textTertiary),
            ),
          ],
          if (_error case final error?) ...[
            const SizedBox(height: DSSpacing.sm),
            Text(
              error,
              style: DSTypography.bodySm.copyWith(color: colors.textError),
            ),
          ],
          const SizedBox(height: DSSpacing.base),
          DSButton(
            label: l10n.walletTopUp,
            size: DSButtonSize.sm,
            fullWidth: true,
            loading: _busy,
            onPressed: allowed ? () => _topUp(amount) : null,
          ),
        ],
      ),
    );
  }
}
