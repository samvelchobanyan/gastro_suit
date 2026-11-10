import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';

/// A place where the user picks up an order (DOMAIN_SPEC §3). Holds what the
/// branch card shows; more fields arrive with the screens that use them.
@freezed
abstract class Branch with _$Branch {
  const factory Branch({
    required String id,
    required String name,
    required String address,
    String? photoUrl,

    /// For the distance to the user; both or neither.
    double? latitude,
    double? longitude,

    /// Today's hours as the server reported them when the list was loaded;
    /// null when the branch has no hours entered.
    TodayHours? today,

    /// Closed for now regardless of its hours (repairs and the like).
    required bool isTemporarilyClosed,
  }) = _Branch;

  const Branch._();

  /// Open at the moment the list was loaded; null when unknown.
  bool? get isOpenNow {
    if (isTemporarilyClosed) return false;
    return switch (today) {
      TodayOpen(:final isOpenNow) => isOpenNow,
      TodayClosed() => false,
      null => null,
    };
  }
}

/// A branch's hours for today, on the branch's own clock.
@freezed
sealed class TodayHours with _$TodayHours {
  /// A working day: opens and closes at `HH:mm`. A closing time earlier than
  /// the opening time runs past midnight.
  const factory TodayHours.open({
    required String opens,
    required String closes,
    required bool isOpenNow,
  }) = TodayOpen;

  /// The week's hours are entered and today is a day off.
  const factory TodayHours.closed() = TodayClosed;
}
