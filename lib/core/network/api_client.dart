import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_exception.dart';

/// Request flag: send without the auth token, and never treat a 401 as an
/// expired session (login, register, logout — a 401 there is the answer).
const kPublicRequest = 'public';

/// The single HTTP entry point. Only the data layer uses it.
///
/// Returns decoded JSON. Every failure leaves as an [AppException]; Dio types
/// never get past this class.
class ApiClient {
  ApiClient({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
    HttpClientAdapter? adapter,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
         ),
       ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
    _dio.interceptors.addAll(interceptors);
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (line) => debugPrint(line.toString()),
        ),
      );
    }
  }

  /// Also used by the bare client of the auth interceptor: a refresh with no
  /// timeout can hang and hold every queued error behind it.
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);

  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    bool public = false,
  }) => _send(
    () => _dio.get<dynamic>(
      path,
      queryParameters: query,
      options: _options(public),
    ),
  );

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool public = false,
  }) => _send(
    () => _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: query,
      options: _options(public),
    ),
  );

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool public = false,
  }) => _send(
    () => _dio.put<dynamic>(
      path,
      data: data,
      queryParameters: query,
      options: _options(public),
    ),
  );

  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool public = false,
  }) => _send(
    () => _dio.patch<dynamic>(
      path,
      data: data,
      queryParameters: query,
      options: _options(public),
    ),
  );

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool public = false,
  }) => _send(
    () => _dio.delete<dynamic>(
      path,
      data: data,
      queryParameters: query,
      options: _options(public),
    ),
  );

  Options _options(bool public) => Options(extra: {kPublicRequest: public});

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  /// The one place where transport failures become [AppException].
  static AppException _translate(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const AppException(AppExceptionKind.timeout);
      case DioExceptionType.connectionError:
        return const AppException(AppExceptionKind.noConnection);
      case DioExceptionType.badResponse:
        return _fromResponse(e.response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const AppException(AppExceptionKind.noConnection);
        }
        return const AppException(AppExceptionKind.unknown);
    }
  }

  /// Reads the API's refusal body: `{ code, message, … }`.
  static AppException _fromResponse(Response<dynamic>? response) {
    final body = response?.data;
    final code = body is Map ? body['code'] : null;
    final message = body is Map ? body['message'] : null;
    return AppException(
      response?.statusCode == 401
          ? AppExceptionKind.unauthorized
          : AppExceptionKind.server,
      code: code is String ? code : null,
      message: message is String ? message : null,
    );
  }
}

/// Built in `main` and injected through `ProviderScope.overrides`.
final apiClientProvider = Provider<ApiClient>(
  (_) => throw UnimplementedError(
    'apiClientProvider must be overridden in ProviderScope',
  ),
);
