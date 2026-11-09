/// What went wrong, in terms the app reacts to.
enum AppExceptionKind {
  /// The device could not reach the server.
  noConnection,

  /// The server did not answer in time.
  timeout,

  /// 401: wrong credentials, or the session is over.
  unauthorized,

  /// The server refused the request (any other error status).
  server,

  /// Anything else, e.g. a response that could not be read.
  unknown,
}

/// The only error type above the data layer. Created from transport failures
/// in one place: `ApiClient`.
class AppException implements Exception {
  const AppException(this.kind, {this.code, this.message});

  final AppExceptionKind kind;

  /// The server's machine-readable reason (`invalid_credentials`,
  /// `email_not_verified`, …). Logic branches on this, never on [message].
  /// Null when the server did not answer.
  final String? code;

  /// One sentence for the user, already in the request's language.
  /// Null when the server did not answer.
  final String? message;

  @override
  String toString() => 'AppException($kind, code: $code, message: $message)';
}
