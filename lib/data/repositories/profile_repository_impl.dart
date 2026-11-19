import '../../core/auth/token_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dto/profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._api, this._tokens);

  final ApiClient _api;
  final TokenStorage _tokens;

  @override
  Future<Profile> getProfile() async => _profile(await _api.get('/profile'));

  @override
  Future<Profile> update({
    required String name,
    required String surname,
    required DateTime? birthday,
    required String? city,
    required Gender? gender,
  }) async => _profile(
    await _api.patch(
      '/profile',
      data: ProfileDto.changes(
        name: name,
        surname: surname,
        birthday: birthday,
        city: city,
        gender: gender,
      ),
    ),
  );

  @override
  Future<Profile> setPhoto(String filePath) async => _profile(
    await _api.putImage('/profile/photo', field: 'photo', filePath: filePath),
  );

  @override
  Future<void> deleteAccount() async {
    // The server takes the request only with this word.
    await _api.delete('/profile', data: {'confirm': 'DELETE'});
    // The account is gone, and the session with it.
    await _tokens.clear();
  }

  static Profile _profile(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return ProfileDto.fromJson(json).toDomain();
  }
}
