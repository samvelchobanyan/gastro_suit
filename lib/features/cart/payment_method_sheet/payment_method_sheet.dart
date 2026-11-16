import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../design_system/components/inputs/ds_payment_method.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/payment_cards_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/load_error_row.dart';
import '../cart_sheet/cart_checkout_controller.dart';

/// Opens the list of ways to pay for the order in a sheet. Choosing one
/// makes it the checkout's and closes the sheet.
Future<void> showPaymentMethods(BuildContext context) =>
    showDSBottomSheet<void>(
      context: context,
      title: AppLocalizations.of(context).paymentMethodsTitle,
      child: const PaymentMethodSheet(),
    );

/// The ways to pay for the order (handoff `PaymentBottomSheet`): the
/// user's saved cards, then a new card.
///
/// Paying with a new card is not built yet: its row is shown and takes no
/// taps. The handoff's wallet, loyalty points and voucher are not offered.
class PaymentMethodSheet extends ConsumerWidget {
  const PaymentMethodSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cards = ref.watch(paymentCardsProvider);

    if (cards.hasError && !cards.hasValue) {
      return LoadErrorRow(onRetry: () => ref.invalidate(paymentCardsProvider));
    }
    if (!cards.hasValue) {
      return Padding(
        padding: const EdgeInsets.all(DSSpacing.xl),
        child: Center(
          child: CircularProgressIndicator(color: context.colors.brandPrimary),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final card in cards.requireValue)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.sm),
              child: DSPaymentMethod(
                icon: PhosphorIcons.creditCard(),
                name: l10n.paymentCard(card.lastDigits),
                onTap: () {
                  ref.read(cartCheckoutProvider.notifier).selectCard(card.id);
                  Navigator.pop(context);
                },
              ),
            ),
          DSPaymentMethod(
            icon: PhosphorIcons.plus(),
            name: l10n.paymentNewCard,
            // TODO: pay with a new card on the bank's page.
            onTap: null,
          ),
        ],
      ),
    );
  }
}
