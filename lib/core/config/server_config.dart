import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';

/// What the API instance offers (`GET /config`). Holds only what screens use
/// so far; module switches, currency and payment arrive with their screens.
@freezed
abstract class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    /// The language content falls back to when a text has no translation in
    /// the app's language.
    required String defaultLanguage,

    /// The branch to open on when the user's position is unknown. Null only
    /// when the instance serves no branch.
    String? defaultBranchId,
  }) = _ServerConfig;
}
