/// Signing in and out. Tokens never leave the data layer: whether the user is
/// signed in is read from `authStatusProvider`.
///
/// Throws only `AppException`.
abstract interface class AuthRepository {
  /// [login] is an email or a phone number.
  Future<void> login({required String login, required String password});

  /// Ends the session on this device. Signs out locally even when the server
  /// can't be reached.
  Future<void> logout();
}
