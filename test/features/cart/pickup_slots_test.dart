import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/features/cart/cart_sheet/pickup_slots.dart';

void main() {
  String hm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';

  Branch branch(TodayHours? today) => Branch(
    id: 'b1',
    name: 'Northern',
    address: '',
    isTemporarilyClosed: false,
    today: today,
  );

  group('pickupSlots', () {
    test('start at the next round ten minutes and widen as the design', () {
      final slots = pickupSlots(DateTime(2026, 11, 13, 13, 42));

      expect(
        [for (final slot in slots) hm(slot)],
        ['13:50', '14:00', '14:15', '14:30', '15:00', '15:30'],
      );
    });

    test('on a round ten minutes the first one is ten minutes ahead', () {
      final slots = pickupSlots(DateTime(2026, 11, 13, 13, 40));

      expect(hm(slots.first), '13:50');
    });

    test('run over the hour and over midnight', () {
      final slots = pickupSlots(DateTime(2026, 11, 13, 23, 55));

      expect(slots.first, DateTime(2026, 11, 14, 0, 0));
      expect(slots.last, DateTime(2026, 11, 14, 1, 40));
    });

    test('stop at the closing time', () {
      final slots = pickupSlots(
        DateTime(2026, 11, 13, 13, 42),
        closesAt: DateTime(2026, 11, 13, 14, 15),
      );

      expect([for (final slot in slots) hm(slot)], ['13:50', '14:00', '14:15']);
    });

    test('are none when the branch closes before the first one', () {
      final slots = pickupSlots(
        DateTime(2026, 11, 13, 13, 42),
        closesAt: DateTime(2026, 11, 13, 13, 45),
      );

      expect(slots, isEmpty);
    });
  });

  group('closingTime', () {
    final now = DateTime(2026, 11, 13, 13, 42);

    test('is today at the closing hour', () {
      final closes = closingTime(
        branch(
          const TodayHours.open(
            opens: '08:00',
            closes: '22:30',
            isOpenNow: true,
          ),
        ),
        now,
      );

      expect(closes, DateTime(2026, 11, 13, 22, 30));
    });

    test('is tomorrow when the hours run past midnight', () {
      final closes = closingTime(
        branch(
          const TodayHours.open(
            opens: '10:00',
            closes: '02:00',
            isOpenNow: true,
          ),
        ),
        now,
      );

      expect(closes, DateTime(2026, 11, 14, 2, 0));
    });

    test('is unknown without hours for today', () {
      expect(closingTime(branch(null), now), isNull);
      expect(closingTime(branch(const TodayHours.closed()), now), isNull);
      expect(closingTime(null, now), isNull);
    });
  });
}
