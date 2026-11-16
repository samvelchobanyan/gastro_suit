import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/config/app_config.dart';
import '../../core/di/repositories.dart';
import '../entities/wallet.dart';
import 'server_config_state.dart';

/// The user's wallet, shared by every screen that shows it. None for a guest
/// and when the instance has no wallet; loaded again when the user signs in
/// or out.
final walletProvider = FutureProvider<Wallet?>((ref) async {
  if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return null;
  final config = await ref.watch(serverConfigProvider.future);
  if (!config.walletEnabled) return null;
  return ref
      .read(walletRepositoryProvider)
      .getWallet(restaurantId: ref.read(appConfigProvider).restaurantId);
});
