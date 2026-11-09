// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigDto _$ServerConfigDtoFromJson(Map<String, dynamic> json) =>
    ServerConfigDto(
      languages: json['languages'] == null
          ? null
          : ConfigLanguagesDto.fromJson(
              json['languages'] as Map<String, dynamic>,
            ),
    );

ConfigLanguagesDto _$ConfigLanguagesDtoFromJson(Map<String, dynamic> json) =>
    ConfigLanguagesDto(defaultLanguage: json['default'] as String?);
