import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/server_config.dart';

part 'server_config_dto.g.dart';

/// `GET /config` (`ConfigResponse`). Only the fields the app reads.
@JsonSerializable(createToJson: false)
class ServerConfigDto {
  const ServerConfigDto({this.languages});

  factory ServerConfigDto.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigDtoFromJson(json);

  final ConfigLanguagesDto? languages;

  /// English when the instance names no default language: the app's own
  /// fallback, as the UI does.
  ServerConfig toDomain() =>
      ServerConfig(defaultLanguage: languages?.defaultLanguage ?? 'en');
}

@JsonSerializable(createToJson: false)
class ConfigLanguagesDto {
  const ConfigLanguagesDto({this.defaultLanguage});

  factory ConfigLanguagesDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigLanguagesDtoFromJson(json);

  @JsonKey(name: 'default')
  final String? defaultLanguage;
}
