import '../entities/server_config.dart';

/// The API instance's configuration. Throws only `AppException`.
abstract interface class ServerConfigRepository {
  Future<ServerConfig> getConfig();
}
