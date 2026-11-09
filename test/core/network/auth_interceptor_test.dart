import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/token_storage.dart';
import 'package:gastro_suit/core/network/api_client.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/core/network/interceptors/auth_interceptor.dart';

enum RefreshAnswer { newPair, refused, offline }

/// A server that accepts only the current access token and issues a new pair
/// on `/auth/refresh-token`.
class FakeServer implements HttpClientAdapter {
  RefreshAnswer refreshAnswer = RefreshAnswer.newPair;
  String validToken = 'new-access';
  int refreshCalls = 0;
  final sentRefreshTokens = <String>[];
  final authHeaders = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));

    if (options.path == '/auth/refresh-token') {
      refreshCalls++;
      sentRefreshTokens.add((options.data as Map)['refreshToken'] as String);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return switch (refreshAnswer) {
        RefreshAnswer.newPair => _json(201, {
          'accessToken': validToken,
          'refreshToken': 'refresh-2',
        }),
        RefreshAnswer.refused => _json(401, {
          'code': 'refresh_token_invalid',
          'message': 'Invalid or expired refresh token',
        }),
        RefreshAnswer.offline => throw const SocketException('offline'),
      };
    }

    final auth = options.headers['Authorization'] as String?;
    authHeaders.add(auth);
    if (options.extra[kPublicRequest] == true) {
      return _json(401, {'code': 'invalid_credentials', 'message': 'Invalid'});
    }
    if (auth != 'Bearer $validToken') {
      return _json(401, {'code': 'unauthorized', 'message': 'Expired'});
    }
    return _json(200, {'ok': true});
  }

  static ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeServer server;
  late TokenStorage tokens;
  late ApiClient api;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    server = FakeServer();
    tokens = TokenStorage();
    await tokens.save((access: 'old-access', refresh: 'refresh-1'));

    final session = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = server;
    api = ApiClient(
      baseUrl: 'http://test',
      adapter: server,
      interceptors: [
        AuthInterceptor(tokenStorage: tokens, sessionClient: session),
      ],
    );
  });

  test('renews an expired token and retries the request', () async {
    expect(await api.get('/data'), {'ok': true});

    expect(server.refreshCalls, 1);
    expect(server.sentRefreshTokens, ['refresh-1']);
    expect(tokens.accessToken, 'new-access');
    expect(tokens.refreshToken, 'refresh-2');
  });

  test('parallel 401s share one refresh', () async {
    final results = await Future.wait([
      api.get('/a'),
      api.get('/b'),
      api.get('/c'),
    ]);

    expect(results, everyElement({'ok': true}));
    expect(server.refreshCalls, 1);
  });

  test('a refused refresh signs the user out', () async {
    server.refreshAnswer = RefreshAnswer.refused;

    await expectLater(
      api.get('/data'),
      throwsA(
        isA<AppException>().having(
          (e) => e.kind,
          'kind',
          AppExceptionKind.unauthorized,
        ),
      ),
    );
    expect(server.refreshCalls, 1);
    expect(tokens.hasSession, isFalse);
  });

  test('an unreachable refresh keeps the session', () async {
    server.refreshAnswer = RefreshAnswer.offline;

    await expectLater(api.get('/data'), throwsA(isA<AppException>()));
    expect(tokens.hasSession, isTrue);
  });

  test('a 401 on a public request is an answer, not an expired session', () {
    expect(
      api.post('/auth/login', public: true),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', 'invalid_credentials')
            .having((e) => e.message, 'message', 'Invalid'),
      ),
    );
    expect(server.refreshCalls, 0);
    expect(server.authHeaders, everyElement(isNull));
  });
}
