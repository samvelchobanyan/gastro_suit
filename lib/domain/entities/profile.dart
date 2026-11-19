import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

enum Gender { male, female }

/// The signed-in user, as far as the app shows them.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String name,
    required String surname,

    /// Null for a user who registered by email.
    String? phone,
    String? email,
    String? photoUrl,

    /// The day the user was born; the time of day means nothing.
    DateTime? birthday,

    /// The city the user lives in, as the app saved it: the id of one of
    /// the organisation's cities. May be a text the app does not know when
    /// it was saved elsewhere.
    String? city,
    Gender? gender,
  }) = _Profile;

  const Profile._();

  /// The name and the surname as one line; empty when the user gave neither.
  String get fullName => '$name $surname'.trim();

  /// What the user signs in with, to show under the name: the phone,
  /// otherwise the email.
  String? get contact => phone ?? email;
}
