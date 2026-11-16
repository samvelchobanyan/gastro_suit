import '../entities/loyalty_card.dart';

/// The signed-in user's loyalty card. Throws only `AppException`.
abstract interface class LoyaltyRepository {
  /// The user's card at the organisation [restaurantId].
  Future<LoyaltyCard> getCard({required String restaurantId});
}
