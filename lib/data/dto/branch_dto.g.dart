// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchDto _$BranchDtoFromJson(Map<String, dynamic> json) => BranchDto(
  id: json['id'] as String,
  internalName: json['internalName'] as String?,
  name: translationsFromJson(json['name']),
  address: translationsFromJson(json['address']),
  description: translationsFromJson(json['description']),
  photoUrl: json['photoUrl'] as String?,
  rating: json['rating'] == null
      ? null
      : BranchRatingDto.fromJson(json['rating'] as Map<String, dynamic>),
  cityId: json['cityId'] as String?,
  districtId: json['districtId'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  today: json['today'] == null
      ? null
      : TodayHoursDto.fromJson(json['today'] as Map<String, dynamic>),
  isTemporarilyClosed: json['isTemporarilyClosed'] as bool?,
);

TodayHoursDto _$TodayHoursDtoFromJson(Map<String, dynamic> json) =>
    TodayHoursDto(
      open: json['open'] as String?,
      close: json['close'] as String?,
      openNow: json['openNow'] as bool?,
    );

BranchRatingDto _$BranchRatingDtoFromJson(Map<String, dynamic> json) =>
    BranchRatingDto(
      average: json['average'] as num?,
      count: json['count'] as num?,
    );
