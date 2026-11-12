import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/branch.dart';
import 'localized_text.dart';

part 'branch_dto.g.dart';

/// `LocationResponse` from `GET /branches`. Only what the app uses is read.
@JsonSerializable(createToJson: false)
class BranchDto {
  const BranchDto({
    required this.id,
    this.internalName,
    this.name,
    this.address,
    this.description,
    this.photoUrl,
    this.rating,
    this.cityId,
    this.districtId,
    this.latitude,
    this.longitude,
    this.today,
    this.isTemporarilyClosed,
  });

  factory BranchDto.fromJson(Map<String, dynamic> json) =>
      _$BranchDtoFromJson(json);

  final String id;
  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? address;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? description;

  final String? photoUrl;
  final BranchRatingDto? rating;
  final String? cityId;
  final String? districtId;
  final double? latitude;
  final double? longitude;
  final TodayHoursDto? today;
  final bool? isTemporarilyClosed;

  Branch toDomain(ContentLanguage language) {
    final hasCoordinates = latitude != null && longitude != null;
    return Branch(
      id: id,
      name: localized(name, language, internalName: internalName),
      address: localized(address, language),
      description: localizedOrNull(description, language),
      photoUrl: photoUrl == null || photoUrl!.isEmpty ? null : photoUrl,
      rating: rating?.toDomain(),
      cityId: cityId,
      districtId: districtId,
      latitude: hasCoordinates ? latitude : null,
      longitude: hasCoordinates ? longitude : null,
      today: today?.toDomain(),
      isTemporarilyClosed: isTemporarilyClosed ?? false,
    );
  }
}

/// `TodayHoursResponse`: `{ open, close, openNow }`. Both times are null on
/// a day off.
@JsonSerializable(createToJson: false)
class TodayHoursDto {
  const TodayHoursDto({this.open, this.close, this.openNow});

  factory TodayHoursDto.fromJson(Map<String, dynamic> json) =>
      _$TodayHoursDtoFromJson(json);

  final String? open;
  final String? close;
  final bool? openNow;

  /// Null with only one of the two times: the card then shows no hours
  /// rather than wrong ones.
  TodayHours? toDomain() {
    final open = this.open;
    final close = this.close;
    if (open == null && close == null) return const TodayHours.closed();
    if (open == null || close == null) return null;
    return TodayHours.open(
      opens: open,
      closes: close,
      isOpenNow: openNow ?? false,
    );
  }
}

/// `RatingResponse`.
@JsonSerializable(createToJson: false)
class BranchRatingDto {
  const BranchRatingDto({this.average, this.count});

  factory BranchRatingDto.fromJson(Map<String, dynamic> json) =>
      _$BranchRatingDtoFromJson(json);

  final num? average;
  final num? count;

  /// Null without an average: no rating is shown rather than a zero.
  BranchRating? toDomain() {
    final average = this.average;
    if (average == null) return null;
    return BranchRating(
      average: average.toDouble(),
      count: count?.toInt() ?? 0,
    );
  }
}
