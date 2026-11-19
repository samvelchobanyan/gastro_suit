import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../dto/json_list.dart';
import '../dto/product_dto.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Set<String>> getFavorites() async =>
      _ids(await _api.get('/favorites'));

  @override
  Future<List<Product>> getProducts(ContentLanguage language) async {
    // `FavouriteItemResponse`: the dish under `item`, as the menu gives it.
    final json = await _api.get('/favorites/items');
    return [
      for (final entry in jsonObjectList(json))
        if (entry['item'] case final Map<String, dynamic> item)
          ProductDto.fromJson(item).toDomain(language),
    ];
  }

  @override
  Future<Set<String>> add(String productId) async =>
      _ids(await _api.post('/favorites/$productId'));

  @override
  Future<Set<String>> remove(String productId) async =>
      _ids(await _api.delete('/favorites/$productId'));

  /// Reads `FavouritesResponse`. No DTO: the answer is a list of ids and
  /// nothing else.
  static Set<String> _ids(Object? json) {
    final ids = json is Map ? json['favoriteItemIds'] : null;
    if (ids is! List) throw const AppException(AppExceptionKind.unknown);
    return ids.whereType<String>().toSet();
  }
}
