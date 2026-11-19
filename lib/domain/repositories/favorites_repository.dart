import '../../core/locale/content_language.dart';
import '../entities/product.dart';

/// The signed-in user's favourite products, as their ids (DOMAIN_SPEC §1):
/// one set for the account, the same at every branch. Throws only
/// `AppException`.
abstract interface class FavoritesRepository {
  Future<Set<String>> getFavorites();

  /// The favourites as products, each as one of the branches that sell it
  /// offers it. For showing a favourite the menu at hand does not have.
  Future<List<Product>> getProducts(ContentLanguage language);

  /// Marks [productId] as a favourite. Answers with the whole set as the
  /// server now holds it.
  Future<Set<String>> add(String productId);

  /// Takes [productId] out of the favourites. Answers with the whole set as
  /// the server now holds it.
  Future<Set<String>> remove(String productId);
}
