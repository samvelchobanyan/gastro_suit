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
