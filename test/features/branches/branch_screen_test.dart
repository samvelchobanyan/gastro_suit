import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/feedback/ds_rating_stars.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/branches/branch_screen/branch_screen.dart';
import 'package:gastro_suit/features/menu/widgets/menu_product_card.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

class _FakeBranches extends BranchesController {
  _FakeBranches(this.branches);

  final List<Branch> branches;

  @override
  Future<List<NearbyBranch>> build() async => [
    for (final branch in branches) NearbyBranch(branch, null),
  ];
}

class _FakeMenu extends BranchMenuController {
  _FakeMenu(this.menu) : super(menu.branchId);

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  const menu = Menu(
    branchId: 'b1',
    categories: [MenuCategory(id: 'sweets', name: 'Sweets')],
    products: [
      Product(
        id: 'p1',
        categoryId: 'sweets',
        name: 'Muffin',
        price: 1250,
        isAvailable: true,
        isFeatured: false,
        sizes: [],
        optionGroups: [],
      ),
    ],
  );

  const branch = Branch(
    id: 'b1',
    name: 'Northern Avenue',
    address: 'Northern Avenue 12/1, Yerevan',
    description: 'Open around the clock',
    today: TodayHours.open(opens: '08:00', closes: '23:00', isOpenNow: true),
    isTemporarilyClosed: false,
  );

  Future<void> pumpScreen(
    WidgetTester tester, {
    required List<Branch> branches,
  }) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          branchesControllerProvider.overrideWith(
            () => _FakeBranches(branches),
          ),
          menuProvider('b1').overrideWith(() => _FakeMenu(menu)),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const BranchScreen(branchId: 'b1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the branch, its menu and the checkout bar', (
    tester,
  ) async {
    await pumpScreen(tester, branches: [branch]);

    expect(find.text('Northern Avenue'), findsOneWidget);
    expect(find.text('Open around the clock'), findsOneWidget);
    expect(find.text('Northern Avenue 12/1, Yerevan'), findsOneWidget);
    expect(find.text('08:00 – 23:00'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.byType(MenuProductCard), findsOneWidget);
    expect(find.text('֏1,250'), findsOneWidget);
    expect(find.text('Checkout · ֏0'), findsOneWidget);
  });

  testWidgets('a branch nobody has rated shows empty stars and no number', (
    tester,
  ) async {
    await pumpScreen(tester, branches: [branch]);

    expect(tester.widget<DSRatingStars>(find.byType(DSRatingStars)).value, 0);
    expect(find.text('0.0'), findsNothing);
  });

  testWidgets('a rated branch shows the average and the count', (tester) async {
    await pumpScreen(
      tester,
      branches: [
        branch.copyWith(rating: const BranchRating(average: 4.7, count: 218)),
      ],
    );

    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('(218)'), findsOneWidget);
  });

  testWidgets('a branch the list does not have shows the error', (
    tester,
  ) async {
    await pumpScreen(tester, branches: const []);

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Menu'), findsNothing);
  });
}
