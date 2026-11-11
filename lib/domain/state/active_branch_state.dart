import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/branch.dart';
import 'branches_state.dart';
import 'server_config_state.dart';

/// The branch the user picked in the branch sheet this session, as an id;
/// null until they pick one. Kept apart from [activeBranchProvider] so that
/// recomputing the active branch (pull-to-refresh) does not lose the pick.
/// Cleared on restart (IMPLEMENTATION_NOTES §7).
class BranchPickController extends Notifier<String?> {
  @override
  String? build() => null;

  void pick(String branchId) => state = branchId;
}

final branchPickProvider = NotifierProvider<BranchPickController, String?>(
  BranchPickController.new,
);

/// The branch the app works with: its menu, prices and cart. Recomputed
/// when the branch list or the pick changes; see [chooseActiveBranch].
///
/// Null only when the organisation has no branches. A failed `/config` does
/// not fail it: the branch is chosen without the default.
final activeBranchProvider = FutureProvider<Branch?>((ref) async {
  // Every watch before the first await.
  final pickedId = ref.watch(branchPickProvider);
  final configFuture = ref.watch(serverConfigProvider.future);
  final branchesFuture = ref.watch(branchesControllerProvider.future);

  String? defaultId;
  try {
    defaultId = (await configFuture).defaultBranchId;
  } catch (_) {
    defaultId = null;
  }
  final branches = await branchesFuture;
  return chooseActiveBranch(branches, pickedId: pickedId, defaultId: defaultId);
});

/// The active branch out of [branches] (nearest first):
/// 1. the user's pick, while it is still in the list;
/// 2. the nearest, when the user's position is known;
/// 3. the default branch from `/config`;
/// 4. the first branch.
Branch? chooseActiveBranch(
  List<NearbyBranch> branches, {
  String? pickedId,
  String? defaultId,
}) {
  if (branches.isEmpty) return null;

  Branch? byId(String? id) {
    if (id == null) return null;
    for (final item in branches) {
      if (item.branch.id == id) return item.branch;
    }
    return null;
  }

  final nearest = branches.first;
  return byId(pickedId) ??
      (nearest.distanceKm != null ? nearest.branch : null) ??
      byId(defaultId) ??
      nearest.branch;
}
