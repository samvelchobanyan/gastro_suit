import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/cart.dart';
import '../entities/product_choice.dart';
import 'active_branch_state.dart';
import 'server_config_state.dart';

/// The user's cart at the active branch, shared by every screen that shows
/// it or changes it.
///
/// Null for a guest (the server keeps a cart only for an account) and
/// while there is no active branch. Loaded again when the user signs in or
/// out and when the active branch changes.
///
/// Every change goes to the server and puts the cart it answers with in
/// place of the one held. A change that fails throws its `AppException`
/// and leaves the cart as it was.
class CartController extends AsyncNotifier<Cart?> {
  @override
  Future<Cart?> build() async {
    // Every watch before the first await.
    final signedIn = ref.watch(authStatusProvider) == AuthStatus.signedIn;
    final branchFuture = ref.watch(activeBranchProvider.future);
    final languageFuture = ref.watch(contentLanguageProvider.future);

    final branch = await branchFuture;
    if (!signedIn || branch == null) return null;
    return ref
        .read(cartRepositoryProvider)
        .getCart(branchId: branch.id, language: await languageFuture);
  }

  /// Adds [quantity] of [choice] at [branchId].
  ///
  /// The cart belongs to one branch: adding at another replaces the cart
  /// with this one product, and that branch becomes the active one.
  /// Whoever calls this asks the user first when that would lose a cart.
  Future<void> add({
    required String branchId,
    required ProductChoice choice,
    int quantity = 1,
  }) async {
    final cart = await ref
        .read(cartRepositoryProvider)
        .addItem(
          branchId: branchId,
          choice: choice,
          quantity: quantity,
          language: await ref.read(contentLanguageProvider.future),
        );
    state = AsyncData(cart);
    final active = await ref.read(activeBranchProvider.future);
    if (active?.id != branchId) {
      ref.read(branchPickProvider.notifier).pick(branchId);
    }
  }

  /// Sets the quantity of the line [lineId]; 0 removes it.
  Future<void> setQuantity(String lineId, int quantity) async {
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .setQuantity(
            lineId,
            quantity: quantity,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  }

  Future<void> removeLine(String lineId) async {
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .removeLine(
            lineId,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  }

  /// Empties the cart. Does nothing when there is none.
  Future<void> clear() async {
    final cart = state.value;
    if (cart == null) return;
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .clear(
            branchId: cart.branchId,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  }
}

final cartProvider = AsyncNotifierProvider<CartController, Cart?>(
  CartController.new,
);
