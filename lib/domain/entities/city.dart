import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';

/// A city the organisation's branches stand in, for the branch picker.
@freezed
abstract class City with _$City {
  const factory City({
    required String id,
    required String name,

    /// In the admins' order; empty when the city is not split into
    /// districts.
    required List<District> districts,
  }) = _City;
}

/// A part of a [City] with branches in it.
@freezed
abstract class District with _$District {
  const factory District({required String id, required String name}) =
      _District;
}
