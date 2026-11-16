import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
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
}
