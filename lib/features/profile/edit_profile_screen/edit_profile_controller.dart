import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_exception.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/state/profile_state.dart';

part 'edit_profile_controller.freezed.dart';

/// What the user may change about themselves, as the form holds it. The
/// birthday is in three parts, because each is chosen on its own.
@freezed
abstract class ProfileDraft with _$ProfileDraft {
  const factory ProfileDraft({
    @Default('') String name,
    @Default('') String surname,
    int? day,
    int? month,
    int? year,
    String? city,
    Gender? gender,
  }) = _ProfileDraft;

  const ProfileDraft._();

  factory ProfileDraft.of(Profile? profile) => ProfileDraft(
    name: profile?.name ?? '',
    surname: profile?.surname ?? '',
    day: profile?.birthday?.day,
    month: profile?.birthday?.month,
    year: profile?.birthday?.year,
    city: profile?.city,
    gender: profile?.gender,
  );

  /// Null until the day, the month and the year are all chosen.
  DateTime? get birthday {
    final (day, month, year) = (this.day, this.month, this.year);
    return day == null || month == null || year == null
        ? null
        : DateTime(year, month, day);
  }

  /// Whether the birthday can be saved: chosen in full or not at all.
  bool get birthdayIsWhole =>
      birthday != null || (day == null && month == null && year == null);

  /// How many days the chosen month has; the most a month may have while
  /// the month or the year is not chosen.
  int get daysInMonth {
    final month = this.month;
    if (month == null) return 31;
    // Day 0 of the next month is the last day of this one. Without a year,
    // a leap one: February 29 is a day somebody was born on.
    return DateTime(year ?? 2000, month + 1, 0).day;
  }

  /// The draft as it is sent: without the spaces around the names.
  ProfileDraft get trimmed =>
      copyWith(name: name.trim(), surname: surname.trim());
}

/// The form of the Edit profile screen.
@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    required ProfileDraft draft,

    /// The draft the form was opened with: what the server holds.
    required ProfileDraft saved,
    @Default(false) bool saving,

    /// Why the last save was refused.
    AppException? error,
  }) = _EditProfileState;

  const EditProfileState._();

  bool get canSave =>
      !saving && draft.birthdayIsWhole && draft.trimmed != saved.trimmed;
}

/// Holds what the user has entered on the Edit profile screen and saves it.
///
/// The photo is not part of the form: it is saved the moment it is chosen
/// (`ProfileController.setPhoto`).
class EditProfileController extends Notifier<EditProfileState> {
  @override
  EditProfileState build() {
    // Read once: the profile changing under the form (a new photo) must
    // not throw away what the user has entered.
    final draft = ProfileDraft.of(ref.read(profileProvider).value);
    return EditProfileState(draft: draft, saved: draft);
  }

  void _change(ProfileDraft draft) {
    // A day the chosen month does not have is no longer chosen.
    final day = draft.day;
    state = state.copyWith(
      draft: day != null && day > draft.daysInMonth
          ? draft.copyWith(day: null)
          : draft,
      error: null,
    );
  }

  void setName(String name) => _change(state.draft.copyWith(name: name));

  void setSurname(String surname) =>
      _change(state.draft.copyWith(surname: surname));

  void setDay(int day) => _change(state.draft.copyWith(day: day));

  void setMonth(int month) => _change(state.draft.copyWith(month: month));

  void setYear(int year) => _change(state.draft.copyWith(year: year));

  void setCity(String city) => _change(state.draft.copyWith(city: city));

  void setGender(Gender gender) =>
      _change(state.draft.copyWith(gender: gender));

  /// Saves the draft. Answers whether it was saved; a refusal is kept in
  /// the state.
  Future<bool> save() async {
    if (!state.canSave) return false;
    final draft = state.draft.trimmed;
    state = state.copyWith(saving: true, error: null);
    try {
      await ref
          .read(profileProvider.notifier)
          .save(
            name: draft.name,
            surname: draft.surname,
            birthday: draft.birthday,
            city: draft.city,
            gender: draft.gender,
          );
      if (ref.mounted) state = state.copyWith(saving: false, saved: draft);
      return true;
    } on AppException catch (error) {
      if (ref.mounted) state = state.copyWith(saving: false, error: error);
      return false;
    }
  }
}

final editProfileProvider =
    NotifierProvider.autoDispose<EditProfileController, EditProfileState>(
      EditProfileController.new,
    );
