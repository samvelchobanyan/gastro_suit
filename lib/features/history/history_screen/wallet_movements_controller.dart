import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/repositories.dart';
import '../../../domain/entities/wallet_movement.dart';

/// The money that moved through the user's wallet, for the History screen's
/// transactions, newest first.
final walletMovementsProvider =
    FutureProvider.autoDispose<List<WalletMovement>>(
      (ref) => ref
          .read(walletRepositoryProvider)
          .getMovements(restaurantId: ref.read(appConfigProvider).restaurantId),
    );
