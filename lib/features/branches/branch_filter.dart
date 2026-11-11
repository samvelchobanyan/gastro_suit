import '../../design_system/components/inputs/ds_chip_tabs.dart';
import '../../domain/entities/branch.dart';
import '../../domain/entities/city.dart';
import '../../domain/state/branches_state.dart';

/// What a branch list filtered by city and district shows: the filter's
/// controls and the branches that pass it. Computed by [filterBranches],
/// drawn by `BranchAreaFilter` and by the list under it.
class BranchFilter {
  const BranchFilter({
    required this.cities,
    required this.city,
    required this.districts,
    required this.district,
    required this.branches,
  });

  /// The value of the "Other" district chip; district ids are UUIDs, so it
  /// never clashes with one.
  static const otherDistrict = '';

  /// Every city, for the city select.
  final List<City> cities;

  /// The city shown; null only when the server has no cities.
  final City? city;

  /// A chip per district of [city], and an "Other" chip for its branches
  /// that name no district of it. Empty for a city without districts.
  final List<DSChipTab<String>> districts;

  /// The selected chip's value; null when there are no chips.
  final String? district;

  /// The branches of [city] and [district], in the order they came.
  final List<NearbyBranch> branches;
}

/// Works out the filter for [cityId] and [districtId], the user's choices.
///
/// Until the user chooses, the city and the district of [active] (the active
/// branch) are used; without them, the first city and its first district.
/// Without cities from the server every branch is listed.
BranchFilter filterBranches({
  required List<City> cities,
  required List<NearbyBranch> branches,
  required String otherLabel,
  String? cityId,
  String? districtId,
  Branch? active,
}) {
  final wantedCityId = cityId ?? active?.cityId;
  final city =
      cities.where((c) => c.id == wantedCityId).firstOrNull ??
      cities.firstOrNull;

  final inCity = [
    for (final item in branches)
      if (city == null || item.branch.cityId == city.id) item,
  ];

  final cityDistricts = city?.districts ?? const <District>[];
  final districtIds = {for (final d in cityDistricts) d.id};
  bool isOther(Branch b) => !districtIds.contains(b.districtId);
  final chips = [
    for (final d in cityDistricts) DSChipTab(value: d.id, label: d.name),
    if (cityDistricts.isNotEmpty && inCity.any((b) => isOther(b.branch)))
      DSChipTab(value: BranchFilter.otherDistrict, label: otherLabel),
  ];

  // The active branch's chip, while its city is the one shown.
  final activeChip = active == null || active.cityId != city?.id
      ? null
      : isOther(active)
      ? BranchFilter.otherDistrict
      : active.districtId;
  final wanted = districtId ?? activeChip;
  final district = chips.any((c) => c.value == wanted)
      ? wanted
      : chips.firstOrNull?.value;

  return BranchFilter(
    cities: cities,
    city: city,
    districts: chips,
    district: district,
    branches: [
      for (final item in inCity)
        if (district == null ||
            (district == BranchFilter.otherDistrict
                ? isOther(item.branch)
                : item.branch.districtId == district))
          item,
    ],
  );
}
