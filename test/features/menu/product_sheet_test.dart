import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/navigation/app_routes.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_checkbox.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_radio.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_sheet.dart';
import 'package:gastro_suit/features/menu/product_sheet/widgets/product_sheet_photo.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../fakes/fake_cart_controller.dart';

class _FakeMenuController extends BranchMenuController {
  _FakeMenuController(this.menu) : super('b1');

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  Product product({
    String? description,
    Portion? portion,
    bool available = true,
    List<ProductSize> sizes = const [],
    List<ProductOptionGroup> groups = const [],
  }) => Product(
    id: 'p1',
    categoryId: 'c1',
    name: 'Latte',
    description: description,
    price: 1450,
    isAvailable: available,
    portion: portion,
    isFeatured: false,
    sizes: sizes,
    optionGroups: groups,
  );

  /// A page with a button that opens the sheet of product `p1`, with the
  /// status bar and the home indicator of a phone. Answers with the cart
  /// the sheet adds to; [cart] is what it holds to begin with.
  Future<FakeCartController> openSheet(
    WidgetTester tester,
    List<Product> products, {
    AuthStatus auth = AuthStatus.signedIn,
    Cart? cart,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
    addTearDown(tester.view.reset);

    final menu = Menu(
      branchId: 'b1',
      categories: const [MenuCategory(id: 'c1', name: 'Coffee')],
      products: products,
    );
    final fakeCart = FakeCartController(cart);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            // The page keeps the menu loaded, as the screens that open the
            // sheet do.
            body: Consumer(
              builder: (context, ref, _) {
                ref.watch(menuProvider('b1'));
                return Center(
                  child: TextButton(
                    onPressed: () =>
                        showProduct(context, branchId: 'b1', productId: 'p1'),
                    child: const Text('open'),
                  ),
                );
              },
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const Scaffold(body: Text('sign-in page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          menuProvider('b1').overrideWith(() => _FakeMenuController(menu)),
          authStatusProvider.overrideWithValue(auth),
          cartProvider.overrideWith(() => fakeCart),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return fakeCart;
  }

  DSButton addButton(WidgetTester tester) =>
      tester.widget<DSButton>(find.byType(DSButton));

  testWidgets('shows the product and leaves a strip of the screen above', (
    tester,
  ) async {
    await openSheet(tester, [
      product(
        description: 'Espresso with steamed milk',
        portion: const Portion(amount: 300, unit: PortionUnit.milliliter),
      ),
    ]);

    expect(find.text('Latte'), findsOneWidget);
    expect(find.text('֏1,450'), findsOneWidget);
    expect(find.text('300 ml'), findsOneWidget);
    expect(find.text('Espresso with steamed milk'), findsOneWidget);
    expect(find.text('Add · ֏1,450'), findsOneWidget);
    expect(addButton(tester).onPressed, isNotNull);

    // 32 under the 24-high status bar, down to the bottom of the screen.
    final sheet = tester.getRect(find.byType(ProductSheet));
    expect(sheet.top, 56);
    expect(sheet.bottom, 800);
  });

  testWidgets('the button shows what the chosen quantity costs', (
    tester,
  ) async {
    await openSheet(tester, [product()]);

    await tester.tap(find.bySemanticsLabel('Increase quantity'));
    await tester.pump();

    expect(find.text('Add · ֏2,900'), findsOneWidget);
    // The price under the name is still that of one.
    expect(find.text('֏1,450'), findsOneWidget);
  });

  testWidgets('a size changes the price; the portion is left out', (
    tester,
  ) async {
    await openSheet(tester, [
      product(
        portion: const Portion(amount: 300, unit: PortionUnit.milliliter),
        sizes: const [
          ProductSize(
            id: 's',
            name: 'Small',
            price: 1450,
            isAvailable: true,
            isDefault: true,
          ),
          ProductSize(
            id: 'l',
            name: 'Large',
            price: 1850,
            isAvailable: true,
            isDefault: false,
          ),
          ProductSize(
            id: 'xl',
            name: 'Extra',
            price: 2050,
            isAvailable: false,
            isDefault: false,
          ),
        ],
      ),
    ]);

    expect(find.text('300 ml'), findsNothing);
    expect(find.text('Add · ֏1,450'), findsOneWidget);

    await tester.tap(find.text('Large'));
    await tester.pump();
    expect(find.text('Add · ֏1,850'), findsOneWidget);
    // Under the name and on the size itself.
    expect(find.text('֏1,850'), findsNWidgets(2));

    // The branch has run out of this one.
    await tester.tap(find.text('Extra'));
    await tester.pump();
    expect(find.text('Add · ֏1,850'), findsOneWidget);
  });

  testWidgets('a required group keeps the button off until it is filled', (
    tester,
  ) async {
    await openSheet(tester, [
      product(
        groups: const [
          ProductOptionGroup(
            id: 'milk',
            name: 'Milk',
            minSelected: 1,
            maxSelected: 1,
            options: [
              ProductOption(
                id: 'whole',
                name: 'Whole milk',
                price: 0,
                isAvailable: true,
                isDefault: false,
              ),
              ProductOption(
                id: 'oat',
                name: 'Oat milk',
                price: 250,
                isAvailable: true,
                isDefault: false,
              ),
            ],
          ),
        ],
      ),
    ]);

    // One may be chosen: radios, each with its surcharge.
    expect(find.byType(DSRadio), findsNWidgets(2));
    expect(find.text('+֏0'), findsOneWidget);
    expect(find.text('+֏250'), findsOneWidget);
    expect(addButton(tester).onPressed, isNull);

    await tester.tap(find.text('Oat milk'));
    await tester.pump();

    expect(addButton(tester).onPressed, isNotNull);
    expect(find.text('Add · ֏1,700'), findsOneWidget);
  });

  testWidgets('a free group of several choices is plain checkboxes', (
    tester,
  ) async {
    await openSheet(tester, [
      product(
        groups: const [
          ProductOptionGroup(
            id: 'spices',
            name: 'Spices',
            minSelected: 0,
            options: [
              ProductOption(
                id: 'cinnamon',
                name: 'Cinnamon',
                price: 0,
                isAvailable: true,
                isDefault: true,
              ),
              ProductOption(
                id: 'cocoa',
                name: 'Cocoa powder',
                price: 0,
                isAvailable: false,
                isDefault: false,
              ),
            ],
          ),
        ],
      ),
    ]);

    final boxes = tester.widgetList<DSCheckbox>(find.byType(DSCheckbox));
    expect([for (final box in boxes) box.checked], [true, false]);
    expect(find.textContaining('+֏'), findsNothing);

    // The branch has run out of cocoa.
    await tester.tap(find.text('Cocoa powder'));
    await tester.pump();
    expect(
      tester.widgetList<DSCheckbox>(find.byType(DSCheckbox)).last.checked,
      isFalse,
    );
  });

  testWidgets('a stopped product cannot be added', (tester) async {
    await openSheet(tester, [product(available: false)]);

    expect(addButton(tester).onPressed, isNull);
  });

  testWidgets('the add button adds what was chosen and closes the sheet', (
    tester,
  ) async {
    final cart = await openSheet(tester, [
      product(
        sizes: const [
          ProductSize(
            id: 's',
            name: 'Small',
            price: 1450,
            isAvailable: true,
            isDefault: true,
          ),
          ProductSize(
            id: 'l',
            name: 'Large',
            price: 1850,
            isAvailable: true,
            isDefault: false,
          ),
        ],
      ),
    ]);
    await tester.tap(find.text('Large'));
    await tester.tap(find.bySemanticsLabel('Increase quantity'));
    await tester.pump();

    await tester.tap(find.byType(DSButton));
    await tester.pumpAndSettle();

    final (branchId, choice, quantity) = cart.added.single;
    expect(branchId, 'b1');
    expect(choice.productId, 'p1');
    expect(choice.size?.id, 'l');
    expect(choice.options, isEmpty);
    expect(quantity, 2);
    expect(find.byType(ProductSheet), findsNothing);
  });

  testWidgets('a refused add leaves the sheet open and says why', (
    tester,
  ) async {
    final cart = await openSheet(tester, [product()]);
    cart.addError = const AppException(
      AppExceptionKind.server,
      code: 'item_unavailable',
      message: 'The branch has run out of it',
    );

    await tester.tap(find.byType(DSButton));
    await tester.pumpAndSettle();

    expect(find.byType(ProductSheet), findsOneWidget);
    expect(find.text('The branch has run out of it'), findsOneWidget);
    // The button is ready for another try.
    expect(addButton(tester).loading, isFalse);
  });

  testWidgets('a cart of another branch is replaced only when confirmed', (
    tester,
  ) async {
    final cart = await openSheet(tester, [product()], cart: cartAt('b2'));

    await tester.tap(find.byType(DSButton));
    await tester.pumpAndSettle();
    expect(find.text('Clear the cart?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(cart.added, isEmpty);
    expect(find.byType(ProductSheet), findsOneWidget);

    await tester.tap(find.text('Add · ֏1,450'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(cart.added.single.$1, 'b1');
    expect(find.byType(ProductSheet), findsNothing);
  });

  testWidgets('a cart of the same branch is added to without a question', (
    tester,
  ) async {
    final cart = await openSheet(tester, [product()], cart: cartAt('b1'));

    await tester.tap(find.byType(DSButton));
    await tester.pumpAndSettle();

    expect(find.text('Clear the cart?'), findsNothing);
    expect(cart.added, hasLength(1));
  });

  testWidgets('a guest is sent to sign in, over the sheet', (tester) async {
    final cart = await openSheet(tester, [
      product(),
    ], auth: AuthStatus.signedOut);

    await tester.tap(find.byType(DSButton));
    await tester.pumpAndSettle();

    // The sign-in page is on top: it takes the taps, the sheet does not.
    expect(find.text('sign-in page').hitTestable(), findsOneWidget);
    expect(find.byType(DSButton).hitTestable(), findsNothing);

    // Back without signing in: nothing is added, the sheet is still there.
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
    expect(cart.added, isEmpty);
    expect(find.byType(DSButton).hitTestable(), findsOneWidget);
  });

  testWidgets('a drag down over the photo closes the sheet', (tester) async {
    await openSheet(tester, [product()]);

    await tester.drag(find.byType(ProductSheetPhoto), const Offset(0, 500));
    await tester.pumpAndSettle();

    expect(find.byType(ProductSheet), findsNothing);
  });

  testWidgets('a short drag down lets the sheet come back', (tester) async {
    await openSheet(tester, [product()]);

    await tester.drag(find.byType(ProductSheetPhoto), const Offset(0, 120));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(ProductSheet)).top, 56);
  });

  testWidgets('a drag up scrolls the content under the fixed bar', (
    tester,
  ) async {
    await openSheet(tester, [
      product(
        description: 'Espresso with steamed milk',
        groups: [
          for (final name in ['One', 'Two', 'Three'])
            ProductOptionGroup(
              id: name,
              name: name,
              minSelected: 0,
              options: [
                for (var i = 1; i <= 4; i++)
                  ProductOption(
                    id: '$name-$i',
                    name: '$name $i',
                    price: 100,
                    isAvailable: true,
                    isDefault: false,
                  ),
              ],
            ),
        ],
      ),
    ]);
    final bar = tester.getRect(find.byType(DSButton));

    await tester.drag(find.text('Latte'), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(ProductSheet)).top, 56);
    expect(tester.getRect(find.byType(ProductSheetPhoto)).top, lessThan(56));
    expect(tester.getRect(find.byType(DSButton)), bar);
  });

  testWidgets('a product the branch no longer offers shows the error', (
    tester,
  ) async {
    await openSheet(tester, const []);

    expect(find.text('Something went wrong. Please try again.'), findsOne);
    expect(find.byType(DSButton), findsNothing);
  });
}
