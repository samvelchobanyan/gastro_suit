import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/city.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';
import 'package:gastro_suit/features/branches/branch_filter.dart';

void main() {
  const yerevan = City(
    id: 'yerevan',
    name: 'Yerevan',
    districts: [
      District(id: 'kentron', name: 'Kentron'),
      District(id: 'arabkir', name: 'Arabkir'),
    ],
  );
  const gyumri = City(id: 'gyumri', name: 'Gyumri', districts: []);
  const cities = [yerevan, gyumri];

  Branch branch(String id, {String? cityId, String? districtId}) => Branch(
    id: id,
    name: id,
    address: '',
    isTemporarilyClosed: false,
    cityId: cityId,
    districtId: districtId,
  );

  final k1 = branch('k1', cityId: 'yerevan', districtId: 'kentron');
  final k2 = branch('k2', cityId: 'yerevan', districtId: 'kentron');
  final a1 = branch('a1', cityId: 'yerevan', districtId: 'arabkir');
  final g1 = branch('g1', cityId: 'gyumri');
  final g2 = branch('g2', cityId: 'gyumri');
  final all = [k1, a1, g1, k2, g2];

  BranchFilter filter({
    List<City> cities = cities,
    List<Branch>? branches,
    String? cityId,
    String? districtId,
    Branch? active,
  }) => filterBranches(
    cities: cities,
    branches: [for (final b in branches ?? all) NearbyBranch(b, null)],
    otherLabel: 'Other',
    cityId: cityId,
    districtId: districtId,
    active: active,
  );

  List<String> ids(BranchFilter f) => [for (final b in f.branches) b.branch.id];
  List<String> chips(BranchFilter f) => [for (final c in f.districts) c.value];

  test('opens on the active branch\'s city and district', () {
    final f = filter(active: a1);
    expect(f.city, yerevan);
    expect(f.district, 'arabkir');
    expect(ids(f), ['a1']);
  });

  test('without an active branch opens on the first city and district', () {
    final f = filter();
    expect(f.city, yerevan);
    expect(f.district, 'kentron');
    expect(ids(f), ['k1', 'k2']);
  });

  test('the user\'s city and district win over the active branch\'s', () {
    final f = filter(active: a1, cityId: 'yerevan', districtId: 'kentron');
    expect(f.district, 'kentron');
    expect(ids(f), ['k1', 'k2']);
  });

  test('a city without districts has no chips and lists all its branches', () {
    final f = filter(active: k1, cityId: 'gyumri');
    expect(f.city, gyumri);
    expect(f.districts, isEmpty);
    expect(f.district, isNull);
    expect(ids(f), ['g1', 'g2']);
  });

  test('a district of another city falls back to the first chip', () {
    // The active branch is in Gyumri; the user switched to Yerevan.
    final f = filter(active: g1, cityId: 'yerevan');
    expect(f.district, 'kentron');

    final stale = filter(cityId: 'yerevan', districtId: 'gone');
    expect(stale.district, 'kentron');
  });

  group('"Other"', () {
    final lone = branch('lone', cityId: 'yerevan');
    final foreign = branch('foreign', cityId: 'yerevan', districtId: 'x');
    final withOther = [...all, lone, foreign];

    test('is the last chip when a branch names no district of its city', () {
      final f = filter(branches: withOther);
      expect(chips(f), ['kentron', 'arabkir', BranchFilter.otherDistrict]);
      expect(f.districts.last.label, 'Other');
    });

    test('lists those branches', () {
      final f = filter(
        branches: withOther,
        districtId: BranchFilter.otherDistrict,
      );
      expect(ids(f), ['lone', 'foreign']);
    });

    test('is where the sheet opens when the active branch is one', () {
      final f = filter(branches: withOther, active: lone);
      expect(f.district, BranchFilter.otherDistrict);
    });

    test('is absent when every branch names a district', () {
      expect(chips(filter()), ['kentron', 'arabkir']);
    });

    test('is absent in a city without districts', () {
      expect(filter(cityId: 'gyumri').districts, isEmpty);
    });
  });

  test('without cities every branch is listed', () {
    final f = filter(cities: const []);
    expect(f.city, isNull);
    expect(f.districts, isEmpty);
    expect(ids(f), ['k1', 'a1', 'g1', 'k2', 'g2']);
  });
}
