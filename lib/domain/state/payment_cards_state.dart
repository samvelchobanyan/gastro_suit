import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/payment_card.dart';

/// The user's saved cards, shared by every screen that offers or lists
/// them. Empty for a guest; loaded again when the user signs in or out.
final paymentCardsProvider = FutureProvider<List<PaymentCard>>((ref) async {
  if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return const [];
  return ref.read(paymentRepositoryProvider).getCards();
});

/// The card the user picked to pay with, as its id; null until they pick
/// one. One choice for every place that pays, kept until the app is
/// restarted. A pick that is not among the user's cards (another user's, a
/// removed card) counts as none.
class PickedPaymentCardController extends Notifier<String?> {
  @override
  String? build() => null;

  /// One of the user's saved cards.
  void pick(String cardId) => state = cardId;
}

final pickedPaymentCardProvider =
    NotifierProvider<PickedPaymentCardController, String?>(
      PickedPaymentCardController.new,
    );

/// The card to pay with: the one the user picked, otherwise their default
/// card, otherwise their first. Null while the cards load and when the user
/// has none.
final paymentCardProvider = Provider<PaymentCard?>((ref) {
  final cards = ref.watch(paymentCardsProvider).value ?? const [];
  final pickedId = ref.watch(pickedPaymentCardProvider);
  return cards.where((card) => card.id == pickedId).firstOrNull ??
      cards.where((card) => card.isDefault).firstOrNull ??
      cards.firstOrNull;
});
