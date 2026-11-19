import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/buy_again.dart';
import 'server_config_state.dart';

/// What the user ordered before and can order again, newest first, from
/// every branch. Empty for a guest. Read again by whoever places an order.
final buyAgainProvider = FutureProvider<List<BuyAgainItem>>((ref) async {
  if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return const [];
  final language = await ref.watch(contentLanguageProvider.future);
  return ref.read(orderRepositoryProvider).getBuyAgain(language);
});
