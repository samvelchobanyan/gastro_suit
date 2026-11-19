import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../../core/network/app_exception.dart';
import '../entities/product.dart';
import 'server_config_state.dart';

/// The ids of the user's favourite products, shared by every screen that
/// shows or changes them. One set for the account, the same at every
/// branch: which of them a branch sells is read from its menu. Empty for a
/// guest; loaded again when the user signs in or out.
class FavoritesController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return const {};
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  /// Makes [productId] a favourite, or takes it out when it is one.
  ///
  /// The set changes at once, before the server answers: nothing is
  /// computed there. A refused change is taken back and thrown as the
  /// `AppException` it was refused with.
  Future<void> toggle(String productId) async {
    final favorite = !(await future).contains(productId);
    _set(productId, favorite);
    final repository = ref.read(favoritesRepositoryProvider);
    try {
      favorite
          ? await repository.add(productId)
          : await repository.remove(productId);
    } on AppException {
      // Only this product goes back: another change may have been made
      // meanwhile.
      if (ref.mounted) _set(productId, !favorite);
      rethrow;
    }
  }

  void _set(String productId, bool favorite) {
    final current = state.value ?? const <String>{};
    state = AsyncData(
      favorite
          ? {...current, productId}
          : {
              for (final id in current)
                if (id != productId) id,
            },
    );
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, Set<String>>(
      FavoritesController.new,
    );

/// The user's favourites as products, each as one of the branches that
/// sell it offers it. For a favourite the menu at hand does not have: one
/// it has is read from that menu, with that branch's price.
///
/// Read again whenever the favourites change.
final favoriteProductsProvider = FutureProvider<List<Product>>((ref) async {
  final ids = await ref.watch(favoritesProvider.future);
  if (ids.isEmpty) return const [];
  final language = await ref.watch(contentLanguageProvider.future);
  return ref.read(favoritesRepositoryProvider).getProducts(language);
});
