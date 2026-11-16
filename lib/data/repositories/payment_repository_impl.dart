import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_card.dart';
import '../../domain/repositories/payment_repository.dart';
import '../dto/order_dto.dart';
import '../dto/payment_card_dto.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<PaymentCard>> getCards() async {
    final json = await _api.get('/payments/methods');
    if (json is! List) throw const AppException(AppExceptionKind.unknown);
    return [
      for (final card in json)
        if (card is Map<String, dynamic>)
          PaymentCardDto.fromJson(card).toDomain(),
    ];
  }

  @override
  Future<Order> payWithCard(
    String cardId, {
    required String paymentReference,
    required ContentLanguage language,
  }) async {
    final json = await _api.post(
      '/payments/cards/$cardId/pay',
      data: {'orderId': paymentReference},
    );
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    final paid = CardPaidDto.fromJson(json);
    final order = paid.order;
    if (paid.success != true || order == null) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return order.toDomain(language);
  }
}
