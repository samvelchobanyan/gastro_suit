import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/config/app_config.dart';
import '../../core/di/repositories.dart';
import '../entities/loyalty_card.dart';
import 'server_config_state.dart';

/// The user's loyalty card, shared by every screen that shows it. None for a
/// guest and when the instance has no loyalty programme; loaded again when
/// the user signs in or out.
final loyaltyCardProvider = FutureProvider<LoyaltyCard?>((ref) async {
  if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return null;
  final config = await ref.watch(serverConfigProvider.future);
  if (!config.loyaltyEnabled) return null;
  return ref
      .read(loyaltyRepositoryProvider)
      .getCard(restaurantId: ref.read(appConfigProvider).restaurantId);
});
