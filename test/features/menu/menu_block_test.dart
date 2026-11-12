import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_chip_tabs.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/menu/menu_block/menu_block.dart';
import 'package:gastro_suit/features/menu/widgets/menu_product_card.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

class _FakeMenuController extends BranchMenuController {
  _FakeMenuController(this.menu) : super('b1');

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  List<Product> products(String categoryId, int count) => [
    for (var i = 1; i <= count; i++)
      Product(
        id: '$categoryId-$i',
        categoryId: categoryId,
        name: '$categoryId $i',
        price: 1000 + i,
        isAvailable: true,
        isFeatured: false,
        sizes: const [],
        optionGroups: const [],
      ),
  ];

  // Sweets has no subcategories; Combo has three, each three rows long.
  final menu = Menu(
    branchId: 'b1',
    categories: const [
      MenuCategory(id: 'sweets', name: 'Sweets'),
      MenuCategory(id: 'combo', name: 'Combo'),
      MenuCategory(id: 'iced', name: 'Iced', parentId: 'combo'),
      MenuCategory(id: 'hot', name: 'Hot', parentId: 'combo'),
      MenuCategory(id: 'tea', name: 'Tea', parentId: 'combo'),
      MenuCategory(id: 'none', name: 'Empty', parentId: 'combo'),
    ],
    products: [
      ...products('sweets', 2),
      ...products('iced', 6),
      ...products('hot', 6),
      ...products('tea', 6),
    ],
  );

  /// The block under some other content of the page, as screens embed it.
  Future<void> pumpBlock(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          menuProvider('b1').overrideWith(() => _FakeMenuController(menu)),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 200)),
                MenuBlock(branchId: 'b1'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final chips = find.byType(DSChipTabs<String>);
  String? selectedChip(WidgetTester tester) =>
      tester.widget<DSChipTabs<String>>(chips).value;

  // A section's title; its chip carries the same text and comes first.
  Finder sectionTitle(String name) => find.text(name).last;

  ScrollPosition position(WidgetTester tester) =>
      tester.state<ScrollableState>(find.byType(Scrollable).first).position;

  testWidgets('opens on the first category, without chips', (tester) async {
    await pumpBlock(tester);

    expect(find.text('Menu'), findsOneWidget);
    expect(find.byType(MenuProductCard), findsNWidgets(2));
    expect(find.text('sweets 1'), findsOneWidget);
    expect(chips, findsNothing);
  });

  testWidgets('a category with subcategories shows a chip and a section '
      'for each one that has products', (tester) async {
    await pumpBlock(tester);
    await tester.tap(find.text('Combo'));
    await tester.pumpAndSettle();

    expect(
      [
        for (final o in tester.widget<DSChipTabs<String>>(chips).options)
          o.label,
      ],
      ['Iced', 'Hot', 'Tea'],
    );
    expect(selectedChip(tester), 'iced');
    expect(find.text('iced 1'), findsOneWidget);
    expect(find.text('sweets 1'), findsNothing);
  });

  testWidgets('the chips stay at the top while the sections scroll', (
    tester,
  ) async {
    await pumpBlock(tester);
    await tester.tap(find.text('Combo'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(chips).dy, greaterThan(200));

    position(tester).jumpTo(900);
    await tester.pumpAndSettle();

    // Pinned, with the chips' own top padding above them.
    expect(tester.getTopLeft(chips).dy, 8);

    // And still take taps there.
    await tester.tap(find.descendant(of: chips, matching: find.text('Iced')));
    await tester.pumpAndSettle();
    expect(selectedChip(tester), 'iced');
    expect(position(tester).pixels, lessThan(900));
  });

  testWidgets('a chip scrolls its section up to the chips', (tester) async {
    await pumpBlock(tester);
    await tester.tap(find.text('Combo'));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(of: chips, matching: find.text('Hot')));
    await tester.pumpAndSettle();

    expect(selectedChip(tester), 'hot');
    // The title sits right under the chips' bottom padding.
    expect(
      tester.getTopLeft(sectionTitle('Hot')).dy,
      moreOrLessEquals(tester.getBottomLeft(chips).dy + 16, epsilon: 1),
    );
  });

  testWidgets('the chip of the section on top is the selected one', (
    tester,
  ) async {
    await pumpBlock(tester);
    await tester.tap(find.text('Combo'));
    await tester.pumpAndSettle();
    expect(selectedChip(tester), 'iced');

    // Far enough for the second section's title to pass under the chips.
    await tester.tap(find.descendant(of: chips, matching: find.text('Hot')));
    await tester.pumpAndSettle();
    position(tester).jumpTo(position(tester).pixels + 700);
    await tester.pumpAndSettle();
    expect(selectedChip(tester), 'tea');

    position(tester).jumpTo(0);
    await tester.pumpAndSettle();
    expect(selectedChip(tester), 'iced');
  });
}
