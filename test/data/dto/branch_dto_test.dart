import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/branch_dto.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  Map<String, dynamic> json({Object? today, bool closed = false}) => {
    'id': 'b1',
    'internalName': 'Coffee House — Kentron',
    'name': {'en': 'Kentron', 'ru': 'Кентрон'},
    'address': {'en': 'Abovyan 5', 'ru': 'Абовяна 5'},
    'photoUrl': 'http://x/b.png',
    'latitude': 40.18,
    'longitude': 44.51,
    'today': today,
    'isTemporarilyClosed': closed,
  };

  group('BranchDto', () {
    test('maps a branch in the current language', () {
      final branch = BranchDto.fromJson(json()).toDomain(ru);
      expect(branch.name, 'Кентрон');
      expect(branch.address, 'Абовяна 5');
      expect(branch.latitude, 40.18);
      expect(branch.today, isNull);
      expect(branch.isOpenNow, isNull);
    });

    test('a working day', () {
      final branch = BranchDto.fromJson(
        json(
          today: {
            'state': 'hours',
            'open': '08:00',
            'close': '23:00',
            'openNow': true,
          },
        ),
      ).toDomain(ru);
      expect(
        branch.today,
        const TodayHours.open(opens: '08:00', closes: '23:00', isOpenNow: true),
      );
      expect(branch.isOpenNow, isTrue);
    });

    test('a day off is closed', () {
      final branch = BranchDto.fromJson(
        json(today: {'state': 'closed'}),
      ).toDomain(ru);
      expect(branch.today, const TodayHours.closed());
      expect(branch.isOpenNow, isFalse);
    });

    test('temporarily closed wins over the hours', () {
      final branch = BranchDto.fromJson(
        json(
          today: {
            'state': 'hours',
            'open': '08:00',
            'close': '23:00',
            'openNow': true,
          },
          closed: true,
        ),
      ).toDomain(ru);
      expect(branch.isOpenNow, isFalse);
    });

    test('an unknown state shows no hours', () {
      final branch = BranchDto.fromJson(
        json(today: {'state': 'holiday'}),
      ).toDomain(ru);
      expect(branch.today, isNull);
    });
  });

  group('byDistance', () {
    Branch at(String id, double? lat, double? lng) => Branch(
      id: id,
      name: id,
      address: '',
      latitude: lat,
      longitude: lng,
      isTemporarilyClosed: false,
    );

    final far = at('far', 40.80, 43.84); // Gyumri
    final near = at('near', 40.18, 44.51); // Yerevan centre
    final unknown = at('unknown', null, null);

    test('without a position keeps the order and has no distances', () {
      final list = byDistance([far, unknown, near], null);
      expect([for (final b in list) b.branch.id], ['far', 'unknown', 'near']);
      expect(list.every((b) => b.distanceKm == null), isTrue);
    });

    test('with a position sorts nearest first, unknown last', () {
      final list = byDistance(
        [far, unknown, near],
        (latitude: 40.18, longitude: 44.52),
      );
      expect([for (final b in list) b.branch.id], ['near', 'far', 'unknown']);
      expect(list.first.distanceKm, lessThan(1));
      expect(list.last.distanceKm, isNull);
    });
  });
}
