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
  photoUrl: json['photoUrl'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  today: json['today'] == null
      ? null
      : TodayHoursDto.fromJson(json['today'] as Map<String, dynamic>),
  isTemporarilyClosed: json['isTemporarilyClosed'] as bool?,
);

TodayHoursDto _$TodayHoursDtoFromJson(Map<String, dynamic> json) =>
    TodayHoursDto(
      state: json['state'] as String?,
      open: json['open'] as String?,
      close: json['close'] as String?,
      openNow: json['openNow'] as bool?,
    );
