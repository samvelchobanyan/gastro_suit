import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/buy_again.dart';
import '../entities/cart.dart';
import '../entities/product_choice.dart';
import 'active_branch_state.dart';
import 'server_config_state.dart';

/// The user's cart at the active branch, shared by every screen that shows
/// it or changes it.
///
/// Null for a guest (the server keeps a cart only for an account) and
/// while there is no active branch. Loaded again when the user signs in or
/// out and when the active branch changes. The cart follows a change of
/// the active branch made through [moveTo].
///
/// Every change goes to the server and puts the cart it answers with in
/// place of the one held. A change that fails throws its `AppException`
/// and leaves the cart as it was.
///
/// While a change is on its way ([isChanging]) the cart held is not yet
/// the one that change leaves: a quantity counted from it would be counted
/// from the old one. The cards and the cart sheet take no taps meanwhile.
class CartController extends AsyncNotifier<Cart?> {
  var _changes = 0;

  /// Whether a change of the cart is waiting for the server's answer.
  bool get isChanging => _changes > 0;

  Future<void> _changing(Future<void> Function() change) async {
    _changes++;
    try {
      await change();
    } finally {
      _changes--;
    }
  }

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
  }) => _changing(() async {
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
  });

  /// Puts one piece of [item] in the cart as it was ordered, at the branch
  /// it was ordered from, which becomes the active one. As with [add], a
  /// cart of another branch is replaced, and whoever calls this asks the
  /// user first.
  Future<void> addAgain(BuyAgainItem item) => _changing(() async {
    final cart = await ref
        .read(cartRepositoryProvider)
        .addAgain(
          item.id,
          language: await ref.read(contentLanguageProvider.future),
        );
    state = AsyncData(cart);
    final active = await ref.read(activeBranchProvider.future);
    if (active?.id != cart.branchId) {
      ref.read(branchPickProvider.notifier).pick(cart.branchId);
    }
  });

  /// Makes [branchId] the active branch and takes the cart along: its
  /// products go to that branch, each at the price there. One the branch
  /// cannot make stays in the cart, marked unavailable.
  ///
  /// A failed move throws and changes neither the cart nor the branch.
  Future<void> moveTo(String branchId) async {
    // A cart that failed to load is not known to hold anything.
    Cart? cart;
    try {
      cart = await future;
    } catch (_) {
      cart = null;
    }
    if (cart != null && !cart.isEmpty && cart.branchId != branchId) {
      state = AsyncData(
        await ref
            .read(cartRepositoryProvider)
            .moveTo(
              branchId: branchId,
              language: await ref.read(contentLanguageProvider.future),
            ),
      );
    }
    ref.read(branchPickProvider.notifier).pick(branchId);
  }

  /// Sets the quantity of the line [lineId]; 0 removes it.
  Future<void> setQuantity(String lineId, int quantity) => _changing(() async {
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .setQuantity(
            lineId,
            quantity: quantity,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  });

  /// Puts [choice] and [quantity] in place of what the line [lineId]
  /// holds. When another line already holds that choice, the two become
  /// one.
  Future<void> changeLine(
    String lineId, {
    required ProductChoice choice,
    required int quantity,
  }) => _changing(() async {
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .changeLine(
            lineId,
            choice: choice,
            quantity: quantity,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  });

  /// Takes one piece of [productId] out of the cart: from the last of its
  /// lines, which goes when that was its only piece. Does nothing when the
  /// cart holds none.
  ///
  /// The server keeps a line that was added or changed last at the end of
  /// the list, so the last line is the one the user touched last.
  Future<void> removeOne(String productId) async {
    final line = state.value?.lines
        .where((line) => line.choice.productId == productId)
        .lastOrNull;
    if (line == null) return;
    if (line.quantity > 1) {
      await setQuantity(line.id, line.quantity - 1);
    } else {
      await removeLine(line.id);
    }
  }

  Future<void> removeLine(String lineId) => _changing(() async {
    state = AsyncData(
      await ref
          .read(cartRepositoryProvider)
          .removeLine(
            lineId,
            language: await ref.read(contentLanguageProvider.future),
          ),
    );
  });

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

/// How many pieces of each product the cart holds, by the product's id:
/// its lines together. For the cards of the menu of [branchId]; empty when
/// the cart is at another branch.
final cartQuantitiesProvider = Provider.family<Map<String, int>, String>((
  ref,
  branchId,
) {
  final cart = ref.watch(cartProvider).value;
  if (cart == null || cart.branchId != branchId) return const {};
  final quantities = <String, int>{};
  for (final line in cart.lines) {
    quantities.update(
      line.choice.productId,
      (sum) => sum + line.quantity,
      ifAbsent: () => line.quantity,
    );
  }
  return quantities;
});
