import '../../../domain/entities/branch.dart';

/// The gaps between the times offered, in minutes, as the design's row
/// has them: 13:50, 14:00, 14:15, 14:30, 15:00, 15:30.
const _steps = [10, 15, 15, 30, 30];

/// The times an order can be asked for, besides "as soon as possible":
/// from the next round ten minutes after [now], no later than [closesAt].
///
/// Worked out on the device until the server offers the times itself; the
/// real rules (preparation time, the step, another day) are not known yet.
List<DateTime> pickupSlots(DateTime now, {DateTime? closesAt}) {
  final minute = now.minute - now.minute % 10 + 10;
  var slot = DateTime(now.year, now.month, now.day, now.hour, minute);
  final slots = <DateTime>[];
  for (var i = 0; i <= _steps.length; i++) {
    if (closesAt != null && slot.isAfter(closesAt)) break;
    slots.add(slot);
    if (i < _steps.length) slot = slot.add(Duration(minutes: _steps[i]));
  }
  return slots;
}

/// When [branch] closes today, on the device's clock; null when it has no
/// hours for today. A closing time not after the opening time runs past
/// midnight.
DateTime? closingTime(Branch? branch, DateTime now) {
  final today = branch?.today;
  if (today is! TodayOpen) return null;
  final opens = _minutes(today.opens);
  final closes = _minutes(today.closes);
  if (opens == null || closes == null) return null;
  final midnight = DateTime(now.year, now.month, now.day);
  return midnight.add(
    Duration(minutes: closes > opens ? closes : closes + 24 * 60),
  );
}

/// `HH:mm` as minutes from midnight; null when it is not one.
int? _minutes(String time) {
  final parts = time.split(':');
  if (parts.length != 2) return null;
  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);
  if (hours == null || minutes == null) return null;
  return hours * 60 + minutes;
}
