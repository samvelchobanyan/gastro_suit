import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/branch.dart';
import 'localized_text.dart';

part 'branch_dto.g.dart';

/// `LocationResponse` from `GET /branches`. Only what the branch card uses is
/// read.
@JsonSerializable(createToJson: false)
class BranchDto {
  const BranchDto({
    required this.id,
    this.internalName,
    this.name,
    this.address,
    this.photoUrl,
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

  final String? photoUrl;
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
      photoUrl: photoUrl == null || photoUrl!.isEmpty ? null : photoUrl,
      latitude: hasCoordinates ? latitude : null,
      longitude: hasCoordinates ? longitude : null,
      today: today?.toDomain(),
      isTemporarilyClosed: isTemporarilyClosed ?? false,
    );
  }
}

/// `TodayHoursResponse`: `{ state: hours | closed, open?, close?, openNow? }`.
@JsonSerializable(createToJson: false)
class TodayHoursDto {
  const TodayHoursDto({this.state, this.open, this.close, this.openNow});

  factory TodayHoursDto.fromJson(Map<String, dynamic> json) =>
      _$TodayHoursDtoFromJson(json);

  final String? state;
  final String? open;
  final String? close;
  final bool? openNow;

  /// Null for a state the app does not know or `hours` without times: the
  /// card then shows no hours rather than wrong ones.
  TodayHours? toDomain() {
    final open = this.open;
    final close = this.close;
    return switch (state) {
      'closed' => const TodayHours.closed(),
      'hours' when open != null && close != null => TodayHours.open(
        opens: open,
        closes: close,
        isOpenNow: openNow ?? false,
      ),
      _ => null,
    };
  }
}
