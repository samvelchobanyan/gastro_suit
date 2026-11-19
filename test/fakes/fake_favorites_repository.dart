import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/repositories/favorites_repository.dart';

/// A server that keeps the user's favourite products, [ids] to begin with.
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository([Set<String> ids = const {}]) : ids = {...ids};

  final Set<String> ids;

  /// Thrown by the next changes when set.
  Object? error;

  /// How many times the set was read.
  var reads = 0;

  @override
  Future<Set<String>> getFavorites() async {
    reads++;
    return {...ids};
  }

  /// The favourites as some branch sells them; only those still in [ids]
  /// are answered with.
  var products = <Product>[];

  @override
  Future<List<Product>> getProducts(ContentLanguage language) async => [
    for (final product in products)
      if (ids.contains(product.id)) product,
  ];

  @override
  Future<Set<String>> add(String productId) async {
    if (error case final error?) throw error;
    ids.add(productId);
    return {...ids};
  }

  @override
  Future<Set<String>> remove(String productId) async {
    if (error case final error?) throw error;
    ids.remove(productId);
    return {...ids};
  }
}
