import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';

void main() {
  Branch branch(String id) =>
      Branch(id: id, name: id, address: '', isTemporarilyClosed: false);

  // As BranchesController returns them: nearest first when the position is
  // known, the admins' order otherwise.
  final withPosition = [
    NearbyBranch(branch('near'), 0.1),
    NearbyBranch(branch('default'), 2),
    NearbyBranch(branch('picked'), 5),
  ];
  final withoutPosition = [
    NearbyBranch(branch('first'), null),
    NearbyBranch(branch('default'), null),
  ];

  String? active(
    List<NearbyBranch> branches, {
    String? pickedId,
    String? defaultId,
  }) => chooseActiveBranch(
    branches,
    pickedId: pickedId,
    defaultId: defaultId,
  )?.id;

  test('the pick wins over the nearest', () {
    expect(
      active(withPosition, pickedId: 'picked', defaultId: 'default'),
      'picked',
    );
  });

  test('a pick that left the list falls back to the nearest', () {
    expect(active(withPosition, pickedId: 'gone'), 'near');
  });

  test('without a pick the nearest wins over the default', () {
    expect(active(withPosition, defaultId: 'default'), 'near');
  });

  test('without a position the default is used', () {
    expect(active(withoutPosition, defaultId: 'default'), 'default');
  });

  test('without a position or a known default the first is used', () {
    expect(active(withoutPosition), 'first');
    expect(active(withoutPosition, defaultId: 'gone'), 'first');
  });

  test('no branches, no active branch', () {
    expect(active(const [], pickedId: 'picked'), isNull);
  });
}
