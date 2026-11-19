import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile.dart';

part 'profile_dto.g.dart';

/// `ProfileResponse`. Only what the app shows is read; `favoriteItemIds`
/// is left to the favourites, which own that set.
@JsonSerializable(createToJson: false)
class ProfileDto {
  const ProfileDto({
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.photoUrl,
    this.dateOfBirth,
    this.city,
    this.gender,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  final String? name;
  final String? surname;
  final String? phone;
  final String? email;
  final String? photoUrl;

  /// `YYYY-MM-DD`.
  final String? dateOfBirth;
  final String? city;

  /// `male` or `female`.
  final String? gender;

  Profile toDomain() => Profile(
    name: name ?? '',
    surname: surname ?? '',
    phone: _filled(phone),
    email: _filled(email),
    photoUrl: _filled(photoUrl),
    birthday: DateTime.tryParse(dateOfBirth ?? ''),
    city: _filled(city),
    gender: switch (gender) {
      'male' => Gender.male,
      'female' => Gender.female,
      _ => null,
    },
  );

  /// The body of `PATCH /profile` for these values. Everything is sent: an
  /// empty text or a null clears what the server holds.
  static Map<String, dynamic> changes({
    required String name,
    required String surname,
    required DateTime? birthday,
    required String? city,
    required Gender? gender,
  }) => {
    'name': name,
    'surname': surname,
    'dateOfBirth': birthday == null
        ? null
        : '${birthday.year.toString().padLeft(4, '0')}-'
              '${birthday.month.toString().padLeft(2, '0')}-'
              '${birthday.day.toString().padLeft(2, '0')}',
    'city': city ?? '',
    'gender': gender?.name,
  };

  /// An empty text says nothing.
  static String? _filled(String? text) =>
      text == null || text.isEmpty ? null : text;
}
