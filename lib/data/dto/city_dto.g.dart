// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityDto _$CityDtoFromJson(Map<String, dynamic> json) => CityDto(
  id: json['id'] as String,
  name: translationsFromJson(json['name']),
  districts: (json['districts'] as List<dynamic>?)
      ?.map((e) => DistrictDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

DistrictDto _$DistrictDtoFromJson(Map<String, dynamic> json) => DistrictDto(
  id: json['id'] as String,
  name: translationsFromJson(json['name']),
);
