import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/buy_again.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../dto/buy_again_dto.dart';
import '../dto/json_list.dart';
import '../dto/order_dto.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<PlacedOrder> placeOrder({
    required String branchId,
    required DateTime? time,
    required int tip,
    required ContentLanguage language,
  }) async {
    final json = await _api.post(
      '/orders',
      // No payment gateway is named: the server pays through its default.
      data: {
        'branchId': branchId,
        'fulfillmentType': 'pickup',
        if (time != null) 'scheduledAt': time.toUtc().toIso8601String(),
        if (tip > 0) 'tip': tip,
      },
    );
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return OrderPlacedDto.fromJson(json).toDomain(language);
  }

  @override
  Future<List<Order>> getRecentOrders(ContentLanguage language) async {
    // The first page of the history: there is no request for open orders.
    final json = await _api.get('/orders', query: {'limit': 5});
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return [
      for (final item in jsonObjectList(json['items']))
        OrderDto.fromJson(item).toDomain(language),
    ];
  }

  /// How many orders one page of the history holds.
  static const _pageSize = 20;

  @override
  Future<OrderPage> getOrders({
    required int page,
    required ContentLanguage language,
  }) async {
    final json = await _api.get(
      '/orders',
      query: {'page': page, 'limit': _pageSize},
    );
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    final totalPages = json['totalPages'];
    return (
      orders: [
        for (final item in jsonObjectList(json['items']))
          OrderDto.fromJson(item).toDomain(language),
      ],
      hasMore: totalPages is num && page < totalPages,
    );
  }

  @override
  Future<Order> getOrder(String id, ContentLanguage language) async {
    final json = await _api.get('/orders/$id');
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return OrderDto.fromJson(json).toDomain(language);
  }

  /// How many products the buy-again rail holds.
  static const _buyAgainCount = 10;

  @override
  Future<List<BuyAgainItem>> getBuyAgain(ContentLanguage language) async {
    // No branch is named: what was ordered at every branch.
    final json = await _api.get(
      '/orders/buy-again',
      query: {'limit': _buyAgainCount},
    );
    return [
      for (final item in jsonObjectList(json))
        BuyAgainDto.fromJson(item).toDomain(language),
    ];
  }
}
