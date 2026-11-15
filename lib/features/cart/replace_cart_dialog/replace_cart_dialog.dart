import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/overlays/ds_dialog.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/state/cart_state.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Asks the user before adding a product of [branchId] loses the cart:
/// the cart is tied to one branch, and adding at another replaces it.
///
/// True when the caller may go on: there is nothing to lose, or the user
/// agreed to lose it. Asking does not clear the cart; the add does.
Future<bool> confirmReplaceCart(
  BuildContext context,
  WidgetRef ref, {
  required String branchId,
}) async {
  // A cart that failed to load is not known to hold anything.
  Cart? cart;
  try {
    cart = await ref.read(cartProvider.future);
  } catch (_) {
    cart = null;
  }
  if (!context.mounted) return false;
  if (cart == null || cart.isEmpty || cart.branchId == branchId) return true;

  final l10n = AppLocalizations.of(context);
  return showDSConfirmDialog(
    context: context,
    title: l10n.cartReplaceTitle,
    message: l10n.cartReplaceMessage,
    confirmLabel: l10n.cartReplaceConfirm,
    cancelLabel: l10n.cancel,
  );
}
