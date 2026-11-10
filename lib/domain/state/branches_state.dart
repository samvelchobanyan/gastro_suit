import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/di/repositories.dart';
import '../../core/location/location_service.dart';
import '../entities/branch.dart';
import 'server_config_state.dart';

/// A branch with its distance from the user. The distance is not part of the
/// branch: it depends on where the user is (DOMAIN_SPEC §3.3).
class NearbyBranch {
  const NearbyBranch(this.branch, this.distanceKm);

  final Branch branch;

  /// Null when the user's position or the branch's coordinates are unknown.
  final double? distanceKm;
}

/// The organisation's branches, nearest first. Read by Home's nearest
/// branches and, later, the active branch and the Order tab's branch list.
///
/// The branches and the user's position are fetched together; without a
/// position the list keeps the admins' order and has no distances.
class BranchesController extends AsyncNotifier<List<NearbyBranch>> {
  @override
  Future<List<NearbyBranch>> build() async {
    final positionFuture = ref.read(locationServiceProvider).currentPosition();
    final language = await ref.watch(contentLanguageProvider.future);
    final branches = await ref
        .read(branchRepositoryProvider)
        .getBranches(
          restaurantId: ref.read(appConfigProvider).restaurantId,
          language: language,
        );
    return byDistance(branches, await positionFuture);
  }
}

/// Pairs each branch with its distance from [position] and sorts nearest
/// first; branches without coordinates go last, in their original order.
/// Without a position the order is kept.
List<NearbyBranch> byDistance(List<Branch> branches, GeoPoint? position) {
  final nearby = [
    for (final branch in branches)
      NearbyBranch(branch, _distance(branch, position)),
  ];
  if (position == null) return nearby;

  // List.sort is not stable; the index keeps equal distances in place.
  final indexed = nearby.indexed.toList()
    ..sort((a, b) {
      final da = a.$2.distanceKm ?? double.infinity;
      final db = b.$2.distanceKm ?? double.infinity;
      final byDistance = da.compareTo(db);
      return byDistance != 0 ? byDistance : a.$1.compareTo(b.$1);
    });
  return [for (final (_, item) in indexed) item];
}

double? _distance(Branch branch, GeoPoint? position) {
  final latitude = branch.latitude;
  final longitude = branch.longitude;
  if (position == null || latitude == null || longitude == null) return null;
  return LocationService.distanceKm(position, (
    latitude: latitude,
    longitude: longitude,
  ));
}

final branchesControllerProvider =
    AsyncNotifierProvider<BranchesController, List<NearbyBranch>>(
      BranchesController.new,
    );
