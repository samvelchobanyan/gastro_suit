import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/overlays/ds_dialog.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/state/cart_state.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Whether going over to [branchId] loses what [cart] holds: the cart is
/// tied to one branch, and it is not empty at another one.
bool cartWouldBeLost(Cart? cart, String branchId) =>
    cart != null && !cart.isEmpty && cart.branchId != branchId;

/// Asks the user before the cart is lost to a change of branch: adding a
/// product of [branchId], or making [branchId] the active branch.
///
/// True when the caller may go on: there is nothing to lose, or the user
/// agreed to lose it. Asking does not clear the cart; the caller's own
/// action does (adding at the other branch replaces it; a change of the
/// active branch clears it first).
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
  if (!cartWouldBeLost(cart, branchId)) return true;

  final l10n = AppLocalizations.of(context);
  return showDSConfirmDialog(
    context: context,
    title: l10n.cartReplaceTitle,
    message: l10n.cartReplaceMessage,
    confirmLabel: l10n.cartReplaceConfirm,
    cancelLabel: l10n.cancel,
  );
}
