import 'package:dio/dio.dart';

/// Sends the app's language with every request: server messages, allergen
/// labels and validation texts come back in it.
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor(this._languageCode);

  /// Read per request, so a language change applies to the next request.
  final String Function() _languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _languageCode();
    handler.next(options);
  }
}
