import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/branch_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/loyalty_repository_impl.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/promo_banner_repository_impl.dart';
import '../../data/repositories/server_config_repository_impl.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/branch_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/promo_banner_repository.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../auth/token_storage.dart';
import '../network/api_client.dart';

/// Repository interfaces bound to their implementations. Features and domain
/// state read repositories only through these.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final serverConfigRepositoryProvider = Provider<ServerConfigRepository>(
  (ref) => ServerConfigRepositoryImpl(ref.watch(apiClientProvider)),
);

final storyRepositoryProvider = Provider<StoryRepository>(
  (ref) => StoryRepositoryImpl(ref.watch(apiClientProvider)),
);

final branchRepositoryProvider = Provider<BranchRepository>(
  (ref) => BranchRepositoryImpl(ref.watch(apiClientProvider)),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(ref.watch(apiClientProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(ref.watch(apiClientProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImpl(ref.watch(apiClientProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepositoryImpl(ref.watch(apiClientProvider)),
);

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>(
  (ref) => LoyaltyRepositoryImpl(ref.watch(apiClientProvider)),
);

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepositoryImpl(ref.watch(apiClientProvider)),
);

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepositoryImpl(ref.watch(apiClientProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final promoBannerRepositoryProvider = Provider<PromoBannerRepository>(
  (ref) => PromoBannerRepositoryImpl(ref.watch(apiClientProvider)),
);
