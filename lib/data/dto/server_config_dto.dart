import 'package:json_annotation/json_annotation.dart';

import '../../core/config/server_config.dart';

part 'server_config_dto.g.dart';

/// `GET /config` (`ConfigResponse`). Only the fields the app reads.
@JsonSerializable(createToJson: false)
class ServerConfigDto {
  const ServerConfigDto({this.defaultBranchId, this.languages, this.modules});

  factory ServerConfigDto.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigDtoFromJson(json);

  final String? defaultBranchId;
  final ConfigLanguagesDto? languages;
  final ConfigModulesDto? modules;

  /// English when the instance names no default language: the app's own
  /// fallback, as the UI does.
  ServerConfig toDomain() => ServerConfig(
    defaultLanguage: languages?.defaultLanguage ?? 'en',
    defaultBranchId: defaultBranchId,
    // A module the instance does not name is off.
    loyaltyEnabled: modules?.loyalty ?? false,
    walletEnabled: modules?.wallet ?? false,
  );
}

/// `modules`: the parts of the product the instance has switched on.
@JsonSerializable(createToJson: false)
class ConfigModulesDto {
  const ConfigModulesDto({this.loyalty, this.wallet});

  factory ConfigModulesDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigModulesDtoFromJson(json);

  final bool? loyalty;
  final bool? wallet;
}

@JsonSerializable(createToJson: false)
class ConfigLanguagesDto {
  const ConfigLanguagesDto({this.defaultLanguage});

  factory ConfigLanguagesDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigLanguagesDtoFromJson(json);

  @JsonKey(name: 'default')
  final String? defaultLanguage;
}
