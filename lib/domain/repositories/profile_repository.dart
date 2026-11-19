import '../entities/profile.dart';

/// The signed-in user's own account. Throws only `AppException`.
abstract interface class ProfileRepository {
  Future<Profile> getProfile();

  /// Saves what the user may change about themselves and answers with the
  /// profile as it is now. A null clears the value.
  Future<Profile> update({
    required String name,
    required String surname,
    required DateTime? birthday,
    required String? city,
    required Gender? gender,
  });

  /// Makes the image file at [filePath] the user's photo and answers with
  /// the profile as it is now.
  Future<Profile> setPhoto(String filePath);

  /// Asks the server to delete the account and ends the session on this
  /// device. Cannot be undone.
  Future<void> deleteAccount();
}
