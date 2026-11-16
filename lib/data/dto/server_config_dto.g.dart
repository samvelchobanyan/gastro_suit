// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigDto _$ServerConfigDtoFromJson(Map<String, dynamic> json) =>
    ServerConfigDto(
      defaultBranchId: json['defaultBranchId'] as String?,
      languages: json['languages'] == null
          ? null
          : ConfigLanguagesDto.fromJson(
              json['languages'] as Map<String, dynamic>,
            ),
      modules: json['modules'] == null
          ? null
          : ConfigModulesDto.fromJson(json['modules'] as Map<String, dynamic>),
    );

ConfigModulesDto _$ConfigModulesDtoFromJson(Map<String, dynamic> json) =>
    ConfigModulesDto(
      loyalty: json['loyalty'] as bool?,
      wallet: json['wallet'] as bool?,
    );

ConfigLanguagesDto _$ConfigLanguagesDtoFromJson(Map<String, dynamic> json) =>
    ConfigLanguagesDto(defaultLanguage: json['default'] as String?);
