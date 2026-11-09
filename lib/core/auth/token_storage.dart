import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// An access token and the single-use refresh token that buys the next pair.
typedef TokenPair = ({String access, String refresh});

/// Reads the API's `TokenPairResponse` (login, verify-email, verify-otp,
/// refresh-token). Null when [json] is not one.
///
/// Not a DTO: the pair never becomes domain data, it goes straight to
/// [TokenStorage]. `user` is not read yet.
TokenPair? tokenPairFromJson(Object? json) {
  if (json is! Map) return null;
  final access = json['accessToken'];
  final refresh = json['refreshToken'];
  if (access is! String || refresh is! String) return null;
  return (access: access, refresh: refresh);
}

/// Owns the auth tokens: the only place that reads or writes them.
///
/// Persisted in the platform's secure store (Android Keystore, iOS Keychain),
/// mirrored in memory so every request reads them synchronously. Loaded once
/// by [init] before `runApp`.
///
/// The pair is stored under one key, written in one operation. Two keys could
/// end up holding halves of different pairs (app killed between the writes,
/// or a save and a clear interleaving), and the refresh token is single-use.
///
/// Notifies listeners whenever the tokens change; whether the user is signed
/// in is derived from that (`authStatusProvider`), never stored separately.
class TokenStorage extends ChangeNotifier {
  TokenStorage([FlutterSecureStorage storage = const FlutterSecureStorage()])
    : _storage = storage;

  static const _key = 'auth_tokens';

  final FlutterSecureStorage _storage;
  TokenPair? _tokens;

  String? get accessToken => _tokens?.access;
  String? get refreshToken => _tokens?.refresh;
  bool get hasSession => _tokens != null;

  /// Loads the saved pair. A failed or unreadable read (e.g. a reset Android
  /// Keystore) means no session.
  Future<void> init() async {
    try {
      final saved = await _storage.read(key: _key);
      _tokens = saved == null ? null : _decode(saved);
    } catch (_) {
      _tokens = null;
    }
  }

  Future<void> save(TokenPair tokens) async {
    _tokens = tokens;
    notifyListeners();
    await _storage.write(
      key: _key,
      value: jsonEncode({'access': tokens.access, 'refresh': tokens.refresh}),
    );
  }

  Future<void> clear() async {
    final hadTokens = _tokens != null;
    _tokens = null;
    if (hadTokens) notifyListeners();
    await _storage.delete(key: _key);
  }

  static TokenPair? _decode(String saved) {
    final json = jsonDecode(saved);
    if (json is! Map) return null;
    final access = json['access'];
    final refresh = json['refresh'];
    if (access is! String || refresh is! String) return null;
    return (access: access, refresh: refresh);
  }
}

/// Built and initialized in `main`, injected through `ProviderScope.overrides`.
final tokenStorageProvider = Provider<TokenStorage>(
  (_) => throw UnimplementedError(
    'tokenStorageProvider must be overridden in ProviderScope',
  ),
);
