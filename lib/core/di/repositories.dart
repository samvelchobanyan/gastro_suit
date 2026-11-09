import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/promo_banner_repository_impl.dart';
import '../../data/repositories/server_config_repository_impl.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/promo_banner_repository.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../../domain/repositories/story_repository.dart';
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

final promoBannerRepositoryProvider = Provider<PromoBannerRepository>(
  (ref) => PromoBannerRepositoryImpl(ref.watch(apiClientProvider)),
);
