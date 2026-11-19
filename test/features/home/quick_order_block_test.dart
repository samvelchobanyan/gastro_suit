import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_icon_button.dart';
import 'package:gastro_suit/design_system/ds_extensions.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/buy_again.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/payment_card.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/domain/state/payment_cards_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_sheet.dart';
import 'package:gastro_suit/features/home/home_screen/widgets/buy_again_card.dart';
import 'package:gastro_suit/features/home/home_screen/widgets/quick_order_block.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_sheet.dart';
import 'package:gastro_suit/features/shared_widgets/product_card.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';
import '../../fakes/fake_checkout_repositories.dart';
import '../../fakes/fake_favorites_repository.dart';

class _FakeMenu extends BranchMenuController {
  _FakeMenu(this.menu) : super('b1');

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  Product product(
    String id, {
    bool available = true,
    List<ProductSize> sizes = const [],
    List<ProductOptionGroup> groups = const [],
  }) => Product(
    id: id,
    categoryId: 'c1',
    name: 'Product $id',
    price: 1350,
    isAvailable: available,
    isFeatured: false,
    sizes: sizes,
    optionGroups: groups,
  );

  BuyAgainItem again(
    String id, {
    String branchId = 'b1',
    bool available = true,
  }) => BuyAgainItem(
    id: id,
    name: 'Again $id',
    branchId: branchId,
    branchName: 'Branch $branchId',
    isAvailable: available,
  );

  /// The server the last pumped block reads what to buy again from.
  late FakeOrderRepository orders;

  /// The block of a user who ordered [bought] before and whose favourites
  /// are [favorites], at the branch b1 that sells [offered]; [elsewhere]
  /// is how the server lists the favourites. Answers with the cart, which
  /// starts as [inCart].
  Future<FakeCartController> pumpBlock(
    WidgetTester tester, {
    List<BuyAgainItem> bought = const [],
    Set<String> favorites = const {},
    List<Product> offered = const [],
    List<Product> elsewhere = const [],
    Cart? inCart,
    AuthStatus auth = AuthStatus.signedIn,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cart = FakeCartController(inCart);
    orders = FakeOrderRepository()..buyAgain = bought;
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authStatusProvider.overrideWithValue(auth),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(favorites)..products = elsewhere,
          ),
          activeBranchProvider.overrideWith(
            (ref) async => const Branch(
              id: 'b1',
              name: 'Northern Avenue',
              address: '',
              isTemporarilyClosed: false,
            ),
          ),
          menuProvider('b1').overrideWith(
            () => _FakeMenu(
              Menu(branchId: 'b1', categories: const [], products: offered),
            ),
          ),
          recommendedProductsProvider.overrideWith(
            (ref, key) async => const [],
          ),
          cartProvider.overrideWith(() => cart),
          paymentCardsProvider.overrideWith(
            (ref) async => const <PaymentCard>[],
          ),
          orderRepositoryProvider.overrideWithValue(orders),
          paymentRepositoryProvider.overrideWithValue(
            FakePaymentRepository(const []),
          ),
          contentLanguageProvider.overrideWith(
            (ref) async => const ContentLanguage(current: 'en'),
          ),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: QuickOrderBlock()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cart;
  }

  double opacityOf(WidgetTester tester, String name) => tester
      .widget<Opacity>(
        find.ancestor(of: find.text(name), matching: find.byType(Opacity)),
      )
      .opacity;

  testWidgets('shows the favourites the branch sells under their tab', (
    tester,
  ) async {
    await pumpBlock(
      tester,
      favorites: {'p1', 'p3'},
      offered: [product('p1'), product('p2'), product('p3')],
    );

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(find.text('Product p1'), findsOneWidget);
    expect(find.text('Product p2'), findsNothing);
    expect(find.text('Product p3'), findsOneWidget);
    // The tap is the way to the cart; the cards carry no plus.
    expect(find.byType(DSIconButton), findsNothing);
  });

  testWidgets('nothing for a guest or a user without favourites', (
    tester,
  ) async {
    await pumpBlock(
      tester,
      favorites: {'p1'},
      offered: [product('p1')],
      auth: AuthStatus.signedOut,
    );
    expect(find.text('Favorites'), findsNothing);

    await pumpBlock(tester, favorites: {}, offered: [product('p1')]);
    expect(find.text('Favorites'), findsNothing);
    expect(find.byType(ProductCard), findsNothing);
  });

  testWidgets('a tap puts the product in the cart and opens the cart', (
    tester,
  ) async {
    final cart = await pumpBlock(
      tester,
      favorites: {'p1'},
      offered: [product('p1')],
    );

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();

    expect(cart.added, hasLength(1));
    final (branchId, choice, quantity) = cart.added.single;
    expect(branchId, 'b1');
    expect(choice.productId, 'p1');
    expect(quantity, 1);
    expect(find.byType(CartSheet), findsOneWidget);
  });

  testWidgets('a product with choices goes in with the ones it starts with', (
    tester,
  ) async {
    final latte = product(
      'p1',
      sizes: const [
        ProductSize(
          id: 's',
          name: 'Small',
          price: 1350,
          isAvailable: true,
          isDefault: false,
        ),
        ProductSize(
          id: 'm',
          name: 'Regular',
          price: 1550,
          isAvailable: true,
          isDefault: true,
        ),
      ],
      groups: const [
        ProductOptionGroup(
          id: 'milk',
          name: 'Milk',
          minSelected: 1,
          maxSelected: 1,
          options: [
            ProductOption(
              id: 'cow',
              name: 'Cow',
              price: 0,
              isAvailable: true,
              isDefault: true,
            ),
            ProductOption(
              id: 'oat',
              name: 'Oat',
              price: 200,
              isAvailable: true,
              isDefault: false,
            ),
          ],
        ),
      ],
    );
    final cart = await pumpBlock(tester, favorites: {'p1'}, offered: [latte]);

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();

    final (_, choice, _) = cart.added.single;
    expect(choice.size?.id, 'm');
    expect(choice.options.map((o) => o.id), ['cow']);
    expect(find.byType(CartSheet), findsOneWidget);
  });

  testWidgets('a required choice with nothing to start from opens the '
      'product instead', (tester) async {
    final tea = product(
      'p1',
      groups: const [
        ProductOptionGroup(
          id: 'kind',
          name: 'Kind',
          minSelected: 1,
          maxSelected: 1,
          options: [
            ProductOption(
              id: 'green',
              name: 'Green',
              price: 0,
              isAvailable: true,
              isDefault: false,
            ),
          ],
        ),
      ],
    );
    final cart = await pumpBlock(tester, favorites: {'p1'}, offered: [tea]);

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();

    expect(cart.added, isEmpty);
    expect(find.byType(ProductSheet), findsOneWidget);
    expect(find.byType(CartSheet), findsNothing);
  });

  testWidgets('a favourite the branch does not sell is greyed and takes no '
      'tap', (tester) async {
    final cart = await pumpBlock(
      tester,
      favorites: {'p1', 'p9'},
      offered: [product('p1')],
      // The server lists both; the branch's own p1 is the one shown.
      elsewhere: [product('p1'), product('p9')],
    );

    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(opacityOf(tester, 'Product p1'), 1);
    expect(opacityOf(tester, 'Product p9'), DSOpacity.disabled);

    await tester.tap(find.text('Product p9'));
    await tester.pumpAndSettle();
    expect(cart.added, isEmpty);
    expect(find.byType(CartSheet), findsNothing);
  });

  testWidgets('a product the branch has stopped takes no tap', (tester) async {
    final cart = await pumpBlock(
      tester,
      favorites: {'p1'},
      offered: [product('p1', available: false)],
    );

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();
    expect(cart.added, isEmpty);
  });

  testWidgets('a refused add says why and opens nothing', (tester) async {
    final cart = await pumpBlock(
      tester,
      favorites: {'p1'},
      offered: [product('p1')],
    );
    cart.addError = const AppException(AppExceptionKind.noConnection);

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(CartSheet), findsNothing);
  });

  testWidgets('no tap is taken while the cart is changing', (tester) async {
    final cart = await pumpBlock(
      tester,
      favorites: {'p1'},
      offered: [product('p1')],
    );
    cart.changing = true;

    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();
    expect(cart.added, isEmpty);
  });

  group('buy again', () {
    testWidgets('comes first, with the product and its branch on a card', (
      tester,
    ) async {
      await pumpBlock(
        tester,
        bought: [
          again('a1'),
          again('a2', branchId: 'b2'),
        ],
        favorites: {'p1'},
        offered: [product('p1')],
      );

      expect(find.text('Buy again'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.byType(BuyAgainCard), findsNWidgets(2));
      expect(find.text('Again a2'), findsOneWidget);
      expect(find.text('Branch b2'), findsOneWidget);
      expect(find.byType(ProductCard), findsNothing);

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.byType(BuyAgainCard), findsNothing);
      expect(find.text('Product p1'), findsOneWidget);
    });

    testWidgets('without favourites only its tab is shown', (tester) async {
      await pumpBlock(tester, bought: [again('a1')]);

      expect(find.text('Buy again'), findsOneWidget);
      expect(find.text('Favorites'), findsNothing);
    });

    testWidgets('a guest is asked nothing and shown nothing', (tester) async {
      await pumpBlock(
        tester,
        bought: [again('a1')],
        auth: AuthStatus.signedOut,
      );

      expect(find.text('Buy again'), findsNothing);
      expect(orders.buyAgainReads, 0);
    });

    testWidgets('a tap puts it in the cart at its branch and opens the cart', (
      tester,
    ) async {
      final cart = await pumpBlock(
        tester,
        bought: [again('a1', branchId: 'b2')],
      );

      await tester.tap(find.text('Again a1'));
      await tester.pumpAndSettle();

      expect(cart.addedAgain.single.id, 'a1');
      expect(cart.state.value?.branchId, 'b2');
      expect(find.byType(CartSheet), findsOneWidget);
    });

    testWidgets(
      'a cart of another branch is replaced only if the user agrees',
      (tester) async {
        final cart = await pumpBlock(
          tester,
          bought: [again('a1', branchId: 'b2')],
          inCart: cartAt('b1'),
        );

        await tester.tap(find.text('Again a1'));
        await tester.pumpAndSettle();
        expect(cart.addedAgain, isEmpty);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cart.addedAgain, isEmpty);
        expect(cart.state.value?.branchId, 'b1');
        expect(find.byType(CartSheet), findsNothing);
      },
    );

    testWidgets('one its branch cannot make is greyed and takes no tap', (
      tester,
    ) async {
      final cart = await pumpBlock(
        tester,
        bought: [again('a1', available: false)],
      );

      expect(opacityOf(tester, 'Again a1'), DSOpacity.disabled);
      await tester.tap(find.text('Again a1'));
      await tester.pumpAndSettle();
      expect(cart.addedAgain, isEmpty);
    });

    testWidgets('a refused add says why and reads the list again', (
      tester,
    ) async {
      final cart = await pumpBlock(tester, bought: [again('a1')]);
      cart.addError = const AppException(AppExceptionKind.noConnection);
      expect(orders.buyAgainReads, 1);

      await tester.tap(find.text('Again a1'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(CartSheet), findsNothing);
      expect(orders.buyAgainReads, 2);
    });
  });
}
