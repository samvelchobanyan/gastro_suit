import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/product_choice.dart';
import '../../domain/repositories/cart_repository.dart';
import '../dto/cart_dto.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Cart> getCart({
    required String branchId,
    required ContentLanguage language,
  }) async {
    final json = await _api.get('/cart', query: {'branchId': branchId});
    return _cart(json, language);
  }

  @override
  Future<Cart> addItem({
    required String branchId,
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  }) async {
    final size = choice.size;
    final json = await _api.post(
      '/cart/items',
      data: {
        'itemId': choice.productId,
        'branchId': branchId,
        'quantity': quantity,
        // The size and the add-ons in one list of ids; the server knows
        // their names and prices.
        'modifiers': [
          if (size != null) {'id': size.id},
          for (final option in choice.options) {'id': option.id},
        ],
      },
    );
    return _cart(json, language);
  }

  @override
  Future<Cart> setQuantity(
    String lineId, {
    required int quantity,
    required ContentLanguage language,
  }) async {
    final json = await _api.put(
      '/cart/items/$lineId',
      data: {'quantity': quantity},
    );
    return _cart(json, language);
  }

  @override
  Future<Cart> removeLine(
    String lineId, {
    required ContentLanguage language,
  }) async {
    final json = await _api.delete('/cart/items/$lineId');
    return _cart(json, language);
  }

  @override
  Future<Cart> clear({
    required String branchId,
    required ContentLanguage language,
  }) async {
    final json = await _api.delete('/cart', query: {'branchId': branchId});
    return _cart(json, language);
  }

  static Cart _cart(Object? json, ContentLanguage language) {
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return CartDto.fromJson(json).toDomain(language);
  }
}
