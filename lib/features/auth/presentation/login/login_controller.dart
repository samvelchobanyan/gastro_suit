import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/repositories.dart';

/// Login screen state: idle, signing in, or the last failure.
class LoginController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// True when signed in. On failure the error is in [state].
  Future<bool> submit({required String login, required String password}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .login(login: login.trim(), password: password);
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      return false;
    }
  }
}

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, AsyncValue<void>>(
      LoginController.new,
    );
