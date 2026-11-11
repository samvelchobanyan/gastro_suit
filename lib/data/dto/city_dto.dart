import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/city.dart';
import 'localized_text.dart';

part 'city_dto.g.dart';

/// `CityResponse` from `GET /branches/cities`.
@JsonSerializable(createToJson: false)
class CityDto {
  const CityDto({required this.id, this.name, this.districts});

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);

  final String id;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  final List<DistrictDto>? districts;

  City toDomain(ContentLanguage language) => City(
    id: id,
    name: localized(name, language),
    districts: [for (final d in districts ?? const []) d.toDomain(language)],
  );
}

/// `DistrictResponse`.
@JsonSerializable(createToJson: false)
class DistrictDto {
  const DistrictDto({required this.id, this.name});

  factory DistrictDto.fromJson(Map<String, dynamic> json) =>
      _$DistrictDtoFromJson(json);

  final String id;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  District toDomain(ContentLanguage language) =>
      District(id: id, name: localized(name, language));
}
