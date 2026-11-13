import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/city.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/cities_state.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/features/branches/branch_picker_sheet/branch_picker_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';

class _FakeBranches extends BranchesController {
  _FakeBranches(this.branches);

  final List<Branch> branches;

  @override
  Future<List<NearbyBranch>> build() async => [
    for (final branch in branches) NearbyBranch(branch, null),
  ];
}

class _NoCities extends CitiesController {
  @override
  Future<List<City>> build() async => const [];
}

void main() {
  Branch branch(String id, String name) =>
      Branch(id: id, name: name, address: '', isTemporarilyClosed: false);

  final branches = [branch('b1', 'Northern'), branch('b2', 'Cascade')];

  /// The picker open over a page; `b1` is the active branch until another
  /// is picked. Answers with the providers and the cart.
  Future<(ProviderContainer, FakeCartController)> openPicker(
    WidgetTester tester, {
    Cart? cart,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeCart = FakeCartController(cart);
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          branchesControllerProvider.overrideWith(
            () => _FakeBranches(branches),
          ),
          citiesControllerProvider.overrideWith(_NoCities.new),
          activeBranchProvider.overrideWith(
            (ref) async => branches.firstWhere(
              (b) => b.id == (ref.watch(branchPickProvider) ?? 'b1'),
            ),
          ),
          cartProvider.overrideWith(() => fakeCart),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                container = ProviderScope.containerOf(context);
                ref.watch(cartProvider);
                return TextButton(
                  onPressed: () => showBranchPicker(context),
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return (container, fakeCart);
  }

  Future<void> choose(WidgetTester tester, String name) async {
    await tester.tap(find.text(name));
    await tester.pump();
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
  }

  testWidgets('with an empty cart the branch changes without a question', (
    tester,
  ) async {
    final (container, _) = await openPicker(tester);

    await choose(tester, 'Cascade');

    expect(find.text('Clear the cart?'), findsNothing);
    expect(container.read(branchPickProvider), 'b2');
    expect(find.byType(BranchPickerSheet), findsNothing);
  });

  testWidgets('with products in the cart the user is asked first', (
    tester,
  ) async {
    final (container, cart) = await openPicker(tester, cart: cartAt('b1'));

    await choose(tester, 'Cascade');
    expect(find.text('Clear the cart?'), findsOneWidget);

    // No: the branch and the cart stay.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(container.read(branchPickProvider), isNull);
    expect(cart.cleared, 0);
    expect(find.byType(BranchPickerSheet), findsOneWidget);

    // Yes: the cart is cleared, then the branch changes.
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(cart.cleared, 1);
    expect(container.read(branchPickProvider), 'b2');
    expect(find.byType(BranchPickerSheet), findsNothing);
  });

  testWidgets('choosing the branch the cart is at asks nothing', (
    tester,
  ) async {
    final (container, cart) = await openPicker(tester, cart: cartAt('b1'));

    await choose(tester, 'Northern');

    expect(find.text('Clear the cart?'), findsNothing);
    expect(cart.cleared, 0);
    expect(container.read(branchPickProvider), 'b1');
  });
}
