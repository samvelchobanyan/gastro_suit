/// Signing in and out. Tokens never leave the data layer: whether the user is
/// signed in is read from `authStatusProvider`.
///
/// Throws only `AppException`.
abstract interface class AuthRepository {
  /// Sends a sign-in code by SMS to [phone], a whole number with its
  /// country code.
  Future<void> requestCode(String phone);

  /// Signs in with the [code] sent to [phone]. A number without an account
  /// gets one, at the organisation [restaurantId].
  Future<void> signInWithCode({
    required String phone,
    required String code,
    required String restaurantId,
  });

  /// Ends the session on this device. Signs out locally even when the server
  /// can't be reached.
  Future<void> logout();
}
