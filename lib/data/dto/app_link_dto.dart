import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_link.dart';

part 'app_link_dto.g.dart';

/// `AppLinkResponse`: `{ type: item | category | url, target }`.
@JsonSerializable(createToJson: false)
class AppLinkDto {
  const AppLinkDto({this.type, this.target});

  factory AppLinkDto.fromJson(Map<String, dynamic> json) =>
      _$AppLinkDtoFromJson(json);

  final String? type;
  final String? target;

  /// Null for a type the app does not know or an empty target: the tap then
  /// leads nowhere instead of failing.
  AppLink? toDomain() {
    final target = this.target;
    if (target == null || target.isEmpty) return null;
    final type = switch (this.type) {
      'item' => AppLinkType.product,
      'category' => AppLinkType.category,
      'url' => AppLinkType.url,
      _ => null,
    };
    return type == null ? null : AppLink(type: type, target: target);
  }
}
