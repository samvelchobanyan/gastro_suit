import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/profile.dart';

/// The signed-in user, shared by every screen that shows them. None for a
/// guest; loaded again when the user signs in or out.
///
/// A change is kept here as the server answers it, so that every screen
/// shows it without reading the profile again. A refused change throws and
/// leaves the profile as it was.
class ProfileController extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    if (ref.watch(authStatusProvider) != AuthStatus.signedIn) return null;
    return ref.read(profileRepositoryProvider).getProfile();
  }

  Future<void> save({
    required String name,
    required String surname,
    required DateTime? birthday,
    required String? city,
    required Gender? gender,
  }) async {
    final saved = await ref
        .read(profileRepositoryProvider)
        .update(
          name: name,
          surname: surname,
          birthday: birthday,
          city: city,
          gender: gender,
        );
    if (ref.mounted) state = AsyncData(saved);
  }

  /// Makes the image file at [filePath] the user's photo.
  Future<void> setPhoto(String filePath) async {
    final saved = await ref.read(profileRepositoryProvider).setPhoto(filePath);
    if (ref.mounted) state = AsyncData(saved);
  }
}

final profileProvider = AsyncNotifierProvider<ProfileController, Profile?>(
  ProfileController.new,
);
