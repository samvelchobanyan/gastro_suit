import 'package:gastro_suit/domain/entities/profile.dart';
import 'package:gastro_suit/domain/repositories/profile_repository.dart';

/// A server that keeps the user's [profile]; counts what was asked of the
/// account.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.profile);

  Profile profile;

  /// Thrown by the next reads when set.
  Object? error;

  /// Thrown by the next changes when set.
  Object? changeError;

  /// Thrown by the next deletion when set.
  Object? deleteError;

  var updates = 0;
  var deletions = 0;

  /// The files given as the photo, in order.
  final photos = <String>[];

  @override
  Future<Profile> getProfile() async {
    if (error case final error?) throw error;
    return profile;
  }

  @override
  Future<Profile> update({
    required String name,
    required String surname,
    required DateTime? birthday,
    required String? city,
    required Gender? gender,
  }) async {
    if (changeError case final error?) throw error;
    updates++;
    return profile = profile.copyWith(
      name: name,
      surname: surname,
      birthday: birthday,
      city: city,
      gender: gender,
    );
  }

  @override
  Future<Profile> setPhoto(String filePath) async {
    if (changeError case final error?) throw error;
    photos.add(filePath);
    return profile = profile.copyWith(photoUrl: 'http://test/$filePath');
  }

  @override
  Future<void> deleteAccount() async {
    if (deleteError case final error?) throw error;
    deletions++;
  }
}
