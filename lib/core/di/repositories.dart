import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
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
