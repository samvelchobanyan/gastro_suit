import '../../core/locale/content_language.dart';
import '../entities/order.dart';
import '../entities/payment_card.dart';

/// The signed-in user's saved cards and paying with them. Throws only
/// `AppException`.
abstract interface class PaymentRepository {
  Future<List<PaymentCard>> getCards();

  /// Pays an order that awaits payment with the card [cardId].
  /// [paymentReference] is what placing the order answered with. Answers
  /// with the order as it stands once paid; a declined card throws.
  Future<Order> payWithCard(
    String cardId, {
    required String paymentReference,
    required ContentLanguage language,
  });
}
