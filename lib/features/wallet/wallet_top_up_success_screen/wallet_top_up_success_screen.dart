import 'package:flutter/material.dart';

import '../../../core/utils/price_format.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/success_view.dart';

/// Shows that the wallet was topped up by [amount], over the whole app, in
/// place of the sheet it was topped up from (the route [context] belongs
/// to).
void showWalletTopUpSuccess(BuildContext context, int amount) {
  Navigator.of(context, rootNavigator: true).pushReplacement(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => WalletTopUpSuccessScreen(amount: amount),
    ),
  );
}

/// The wallet was topped up (handoff `WalletTopupSuccess`): by how much,
/// and the way back.
class WalletTopUpSuccessScreen extends StatelessWidget {
  const WalletTopUpSuccessScreen({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SuccessView(
      title: l10n.walletTopUpSuccess(formatPrice(context, amount)),
      actionLabel: l10n.continueAction,
      onAction: () => Navigator.pop(context),
    );
  }
}
