import 'package:dio/dio.dart';

import '../../auth/token_storage.dart';
import '../api_client.dart';

/// Attaches the access token and renews it on a 401.
///
/// A `QueuedInterceptor` handles errors one at a time. The first 401 refreshes
/// the pair; the 401s queued behind it see that the token has already changed
/// and only retry. The refresh token is single-use, so a second, parallel
/// exchange would end the session.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio sessionClient,
  }) : _tokens = tokenStorage,
       _session = sessionClient;

  final TokenStorage _tokens;

  /// Bare client (same base URL, no interceptors) for the refresh request and
  /// the retried request. Going through the main client would put their own
  /// errors in the queue behind the error that is waiting for them.
  final Dio _session;

  static const _header = 'Authorization';
  static const _refreshPath = '/auth/refresh-token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.accessToken;
    if (!_isPublic(options) && token != null) {
      options.headers[_header] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 || _isPublic(request)) {
      return handler.next(err);
    }

    final current = _tokens.accessToken;
    final refreshToken = _tokens.refreshToken;
    if (current == null || refreshToken == null) return handler.next(err);

    // Sent with an older token: a queued 401 ahead of this one has already
    // renewed it.
    if (request.headers[_header] != 'Bearer $current') {
      return _retry(request, current, err, handler);
    }

    final TokenPair? renewed;
    try {
      renewed = await _refresh(refreshToken);
    } catch (_) {
      // Server unreachable or answer unreadable: keep the session, report the
      // original failure.
      return handler.next(err);
    }
    if (renewed == null) {
      await _tokens.clear();
      return handler.next(err);
    }
    await _tokens.save(renewed);
    return _retry(request, renewed.access, err, handler);
  }

  /// The new pair, or null when the server refuses the refresh token (the
  /// session is over). Throws when the server can't be reached, answers 5xx,
  /// or sends something that is not a token pair.
  Future<TokenPair?> _refresh(String refreshToken) async {
    final Response<dynamic> response;
    try {
      response = await _session.post<dynamic>(
        _refreshPath,
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) return null;
      rethrow;
    }
    return tokenPairFromJson(response.data) ??
        (throw const FormatException('refresh-token: not a token pair'));
  }

  Future<void> _retry(
    RequestOptions request,
    String accessToken,
    DioException original,
    ErrorInterceptorHandler handler,
  ) async {
    request.headers[_header] = 'Bearer $accessToken';
    try {
      handler.resolve(await _session.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    } catch (_) {
      handler.next(original);
    }
  }

  static bool _isPublic(RequestOptions options) =>
      options.extra[kPublicRequest] == true;
}
