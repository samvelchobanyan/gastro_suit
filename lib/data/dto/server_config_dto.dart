import 'package:json_annotation/json_annotation.dart';

import '../../core/config/server_config.dart';

part 'server_config_dto.g.dart';

/// `GET /config` (`ConfigResponse`). Only the fields the app reads.
@JsonSerializable(createToJson: false)
class ServerConfigDto {
  const ServerConfigDto({
    this.defaultBranchId,
    this.languages,
    this.modules,
    this.wallet,
  });

  factory ServerConfigDto.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigDtoFromJson(json);

  final String? defaultBranchId;
  final ConfigLanguagesDto? languages;
  final ConfigModulesDto? modules;
  final ConfigWalletDto? wallet;

  /// English when the instance names no default language: the app's own
  /// fallback, as the UI does.
  ServerConfig toDomain() => ServerConfig(
    defaultLanguage: languages?.defaultLanguage ?? 'en',
    defaultBranchId: defaultBranchId,
    // A module the instance does not name is off.
    loyaltyEnabled: modules?.loyalty ?? false,
    walletEnabled: modules?.wallet ?? false,
    minTopUp: wallet?.minTopUp?.round(),
    maxTopUp: wallet?.maxTopUp?.round(),
  );
}

/// `wallet`: the limits of a top-up.
@JsonSerializable(createToJson: false)
class ConfigWalletDto {
  const ConfigWalletDto({this.minTopUp, this.maxTopUp});

  factory ConfigWalletDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigWalletDtoFromJson(json);

  final num? minTopUp;
  final num? maxTopUp;
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
