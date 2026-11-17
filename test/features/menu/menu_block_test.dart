import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_chip_tabs.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_stepper.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/menu/menu_block/menu_block.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_sheet.dart';
import 'package:gastro_suit/features/menu/widgets/menu_product_card.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';

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
  /// Answers with the cart its cards add to.
  Future<FakeCartController> pumpBlock(
    WidgetTester tester, {
    Menu? shown,
    Cart? cart,
  }) async {
    final fakeCart = FakeCartController(cart);
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          menuProvider(
            'b1',
          ).overrideWith(() => _FakeMenuController(shown ?? menu)),
          authStatusProvider.overrideWithValue(AuthStatus.signedIn),
          cartProvider.overrideWith(() => fakeCart),
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
    return fakeCart;
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

  /// The number in the one stepper shown.
  String stepperValue(WidgetTester tester) =>
      '${tester.widget<DSStepper>(find.byType(DSStepper)).value}';

  testWidgets('a product without choices: the plus adds it and becomes a '
      'stepper that adds and takes a piece', (tester) async {
    final cart = await pumpBlock(tester);
    expect(find.byType(DSStepper), findsNothing);

    await tester.tap(find.bySemanticsLabel('Add to cart').first);
    await tester.pumpAndSettle();

    final (branchId, choice, quantity) = cart.added.single;
    expect(branchId, 'b1');
    expect(choice.productId, 'sweets-1');
    expect(quantity, 1);
    expect(find.byType(ProductSheet), findsNothing);
    // The other card keeps its plus.
    expect(find.bySemanticsLabel('Add to cart'), findsOneWidget);
    expect(stepperValue(tester), '1');

    await tester.tap(find.bySemanticsLabel('Increase quantity'));
    await tester.pumpAndSettle();
    expect(cart.added, hasLength(2));
    expect(find.byType(ProductSheet), findsNothing);
    expect(stepperValue(tester), '2');

    await tester.tap(find.bySemanticsLabel('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(stepperValue(tester), '1');

    await tester.tap(find.bySemanticsLabel('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(find.byType(DSStepper), findsNothing);
    expect(find.bySemanticsLabel('Add to cart'), findsNWidgets(2));
  });

  group('a product with choices', () {
    // Everything can be left as it is: the size and the milk have defaults.
    const latte = Product(
      id: 'latte',
      categoryId: 'coffee',
      name: 'Latte',
      price: 1200,
      isAvailable: true,
      isFeatured: false,
      sizes: [
        ProductSize(
          id: 'small',
          name: 'Small',
          price: 1200,
          isAvailable: true,
          isDefault: true,
        ),
        ProductSize(
          id: 'large',
          name: 'Large',
          price: 1500,
          isAvailable: true,
          isDefault: false,
        ),
      ],
      optionGroups: [],
    );
    const coffee = Menu(
      branchId: 'b1',
      categories: [MenuCategory(id: 'coffee', name: 'Coffee')],
      products: [latte],
    );

    CartLine line(String id, String productId, String sizeId, int quantity) =>
        CartLine(
          id: id,
          choice: ProductChoice(
            productId: productId,
            productName: productId,
            size: ChosenSize(id: sizeId, name: sizeId),
            options: const [],
          ),
          quantity: quantity,
          unitPrice: 1000,
          total: 1000 * quantity,
          isAvailable: true,
        );

    /// Two lattes small, another product, then one latte large.
    Cart lattes({String branchId = 'b1'}) => Cart(
      id: 'cart',
      branchId: branchId,
      total: 5000,
      lines: [
        line('small', 'latte', 'small', 2),
        line('other', 'raf', 'small', 4),
        line('large', 'latte', 'large', 1),
      ],
    );

    testWidgets('the plus opens it to choose, though it has defaults', (
      tester,
    ) async {
      final cart = await pumpBlock(tester, shown: coffee);

      await tester.tap(find.bySemanticsLabel('Add to cart'));
      await tester.pumpAndSettle();

      expect(cart.added, isEmpty);
      expect(find.byType(ProductSheet), findsOneWidget);
    });

    testWidgets('the stepper counts its lines together, and its plus opens '
        'it', (tester) async {
      final cart = await pumpBlock(tester, shown: coffee, cart: lattes());
      expect(stepperValue(tester), '3');

      await tester.tap(find.bySemanticsLabel('Increase quantity'));
      await tester.pumpAndSettle();

      expect(cart.added, isEmpty);
      expect(find.byType(ProductSheet), findsOneWidget);
    });

    testWidgets('the minus takes a piece from the last of its lines', (
      tester,
    ) async {
      final cart = await pumpBlock(tester, shown: coffee, cart: lattes());

      // The large one was its only piece: the line goes.
      await tester.tap(find.bySemanticsLabel('Decrease quantity'));
      await tester.pumpAndSettle();
      expect(cart.removed, ['large']);
      expect(cart.quantities, isEmpty);
      expect(stepperValue(tester), '2');

      // Then the small ones, a piece at a time.
      await tester.tap(find.bySemanticsLabel('Decrease quantity'));
      await tester.pumpAndSettle();
      expect(cart.quantities, [('small', 1)]);
      expect(stepperValue(tester), '1');

      await tester.tap(find.bySemanticsLabel('Decrease quantity'));
      await tester.pumpAndSettle();
      expect(cart.removed, ['large', 'small']);
      expect(find.byType(DSStepper), findsNothing);
      // The other product's line was never touched.
      expect(cart.state.value!.lines.single.id, 'other');
    });

    testWidgets('takes no taps while the cart is being changed', (
      tester,
    ) async {
      final cart = await pumpBlock(tester, shown: coffee, cart: lattes());
      cart.changing = true;

      await tester.tap(find.bySemanticsLabel('Decrease quantity'));
      await tester.pumpAndSettle();
      expect(cart.removed, isEmpty);
      expect(stepperValue(tester), '3');

      cart.changing = false;
      await tester.tap(find.bySemanticsLabel('Decrease quantity'));
      await tester.pumpAndSettle();
      expect(cart.removed, ['large']);
    });

    testWidgets('a cart at another branch is not counted', (tester) async {
      await pumpBlock(
        tester,
        shown: coffee,
        cart: lattes(branchId: 'b2'),
      );

      expect(find.byType(DSStepper), findsNothing);
      expect(find.bySemanticsLabel('Add to cart'), findsOneWidget);
    });

    testWidgets('one the branch has stopped shows neither', (tester) async {
      await pumpBlock(
        tester,
        shown: coffee.copyWith(products: [latte.copyWith(isAvailable: false)]),
        cart: lattes(),
      );

      expect(find.byType(DSStepper), findsNothing);
      expect(find.bySemanticsLabel('Add to cart'), findsNothing);
    });
  });

  testWidgets('a tap on a product opens it', (tester) async {
    await pumpBlock(tester);

    await tester.tap(find.byType(MenuProductCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(ProductSheet), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ProductSheet),
        matching: find.text('sweets 1'),
      ),
      findsOneWidget,
    );
  });
}
