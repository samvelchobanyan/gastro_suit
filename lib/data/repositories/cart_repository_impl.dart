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
    final json = await _api.post(
      '/cart/items',
      data: {
        'itemId': choice.productId,
        'branchId': branchId,
        'quantity': quantity,
        'modifiers': _modifiers(choice),
      },
    );
    return _cart(json, language);
  }

  @override
  Future<Cart> changeLine(
    String lineId, {
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  }) async {
    final json = await _api.put(
      '/cart/items/$lineId/options',
      // The whole choice, not only what changed.
      data: {'modifiers': _modifiers(choice), 'quantity': quantity},
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
  Future<Cart> moveTo({
    required String branchId,
    required ContentLanguage language,
  }) async {
    final json = await _api.post('/cart/branch', data: {'branchId': branchId});
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

  /// The size and the add-ons in one list of ids; the server knows their
  /// names and prices.
  static List<Map<String, Object>> _modifiers(ProductChoice choice) {
    final size = choice.size;
    return [
      if (size != null) {'id': size.id},
      for (final option in choice.options)
        {'id': option.id, 'quantity': option.quantity},
    ];
  }

  static Cart _cart(Object? json, ContentLanguage language) {
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return CartDto.fromJson(json).toDomain(language);
  }
}
