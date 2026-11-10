import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../core/config/server_config.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../dto/server_config_dto.dart';

class ServerConfigRepositoryImpl implements ServerConfigRepository {
  ServerConfigRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<ServerConfig> getConfig() async {
    final json = await _api.get('/config', public: true);
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return ServerConfigDto.fromJson(json).toDomain();
  }
}
