import '../../core/auth/token_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._tokens);

  final ApiClient _api;
  final TokenStorage _tokens;

  @override
  Future<void> login({required String login, required String password}) async {
    final json = await _api.post(
      '/auth/login',
      data: {'login': login, 'password': password},
      public: true,
    );
    final tokens = tokenPairFromJson(json);
    if (tokens == null) throw const AppException(AppExceptionKind.unknown);
    await _tokens.save(tokens);
  }

  @override
  Future<void> logout() async {
    final refreshToken = _tokens.refreshToken;
    try {
      if (refreshToken != null) {
        await _api.post(
          '/auth/logout',
          data: {'refreshToken': refreshToken},
          public: true,
        );
      }
    } on AppException {
      // The server could not revoke the token; the user still signs out here.
    } finally {
      await _tokens.clear();
    }
  }
}
