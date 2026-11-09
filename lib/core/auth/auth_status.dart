import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'token_storage.dart';

enum AuthStatus { signedIn, signedOut }

/// Whether the user is signed in, derived from [TokenStorage].
///
/// Not stored on its own: sign-in, sign-out and a failed token refresh all
/// change only the tokens, and this follows. A separate flag would drift from
/// the tokens the moment one of those paths forgot to update it.
final authStatusProvider = Provider<AuthStatus>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  void onTokensChanged() => ref.invalidateSelf();
  storage.addListener(onTokensChanged);
  ref.onDispose(() => storage.removeListener(onTokensChanged));
  return storage.hasSession ? AuthStatus.signedIn : AuthStatus.signedOut;
});
