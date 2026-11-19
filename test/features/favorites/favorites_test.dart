import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/favorites_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/favorites/favorites_screen/favorites_screen.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';
import '../../fakes/fake_favorites_repository.dart';

class _FakeMenu extends BranchMenuController {
  _FakeMenu(this.menu) : super('b1');

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  ProviderContainer containerWith(
    FakeFavoritesRepository server, {
    AuthStatus auth = AuthStatus.signedIn,
  }) {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        authStatusProvider.overrideWithValue(auth),
        favoritesRepositoryProvider.overrideWithValue(server),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('the favourites', () {
    test('a guest has none, and the server is not asked', () async {
      final server = FakeFavoritesRepository({'p1'});
      final container = containerWith(server, auth: AuthStatus.signedOut);

      expect(await container.read(favoritesProvider.future), isEmpty);
      expect(server.reads, 0);
    });

    test('a product is added and taken out again', () async {
      final server = FakeFavoritesRepository({'p1'});
      final container = containerWith(server);
      final controller = container.read(favoritesProvider.notifier);
      expect(await container.read(favoritesProvider.future), {'p1'});

      await controller.toggle('p2');
      expect(container.read(favoritesProvider).value, {'p1', 'p2'});
      expect(server.ids, {'p1', 'p2'});

      await controller.toggle('p1');
      expect(container.read(favoritesProvider).value, {'p2'});
      expect(server.ids, {'p2'});
    });

    test('the set changes before the server answers', () async {
      final container = containerWith(FakeFavoritesRepository());
      await container.read(favoritesProvider.future);

      final change = container.read(favoritesProvider.notifier).toggle('p1');
      await Future<void>.value();

      expect(container.read(favoritesProvider).value, {'p1'});
      await change;
    });

    test('a refused change is taken back and thrown', () async {
      final server = FakeFavoritesRepository({'p1'})
        ..error = const AppException(AppExceptionKind.noConnection);
      final container = containerWith(server);
      await container.read(favoritesProvider.future);
      final controller = container.read(favoritesProvider.notifier);

      await expectLater(controller.toggle('p2'), throwsA(isA<AppException>()));
      expect(container.read(favoritesProvider).value, {'p1'});

      await expectLater(controller.toggle('p1'), throwsA(isA<AppException>()));
      expect(container.read(favoritesProvider).value, {'p1'});
    });
  });

  Product product(String id, {bool available = true, Portion? portion}) =>
      Product(
        id: id,
        categoryId: 'c1',
        name: 'Product $id',
        price: 1350,
        isAvailable: available,
        portion: portion,
        isFeatured: false,
        sizes: const [],
        optionGroups: const [],
      );

  /// The screen of a user whose favourites are [favorites], at a branch
  /// that sells [offered]. Answers with the server.
  Future<FakeFavoritesRepository> pumpScreen(
    WidgetTester tester, {
    required Set<String> favorites,
    required List<Product> offered,
  }) async {
    final server = FakeFavoritesRepository(favorites);
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final menu = Menu(
      branchId: 'b1',
      categories: const [MenuCategory(id: 'c1', name: 'Coffee')],
      products: offered,
    );

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authStatusProvider.overrideWithValue(AuthStatus.signedIn),
          favoritesRepositoryProvider.overrideWithValue(server),
          activeBranchProvider.overrideWith(
            (ref) async => const Branch(
              id: 'b1',
              name: 'Northern Avenue',
              address: '',
              isTemporarilyClosed: false,
            ),
          ),
          menuProvider('b1').overrideWith(() => _FakeMenu(menu)),
          recommendedProductsProvider.overrideWith(
            (ref, key) async => const [],
          ),
          cartProvider.overrideWith(() => FakeCartController(null)),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FavoritesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return server;
  }

  group('the Favorite products screen', () {
    testWidgets('lists the favourites the branch sells', (tester) async {
      await pumpScreen(
        tester,
        favorites: {'p1', 'p3', 'elsewhere'},
        offered: [
          product(
            'p1',
            portion: const Portion(amount: 350, unit: PortionUnit.milliliter),
          ),
          product('p2'),
          product('p3'),
        ],
      );

      expect(find.text('Product p1'), findsOneWidget);
      expect(find.text('350 ml'), findsOneWidget);
      expect(find.text('֏1,350'), findsNWidgets(2));
      expect(find.text('Product p3'), findsOneWidget);
      // Not a favourite.
      expect(find.text('Product p2'), findsNothing);
    });

    testWidgets('a product the branch has stopped looks like any other', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        favorites: {'p1'},
        offered: [product('p1', available: false)],
      );

      expect(find.text('Product p1'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Product p1'),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });

    testWidgets('says so when there are no favourites', (tester) async {
      await pumpScreen(tester, favorites: const {}, offered: [product('p1')]);

      expect(find.text('No favorite products yet'), findsOneWidget);
    });

    testWidgets('says so when the branch sells none of them', (tester) async {
      await pumpScreen(
        tester,
        favorites: {'elsewhere'},
        offered: [product('p1')],
      );

      expect(
        find.text('None of your favorite products is sold at this branch'),
        findsOneWidget,
      );
    });

    testWidgets('the heart takes a product out of the list', (tester) async {
      final server = await pumpScreen(
        tester,
        favorites: {'p1', 'p2'},
        offered: [product('p1'), product('p2')],
      );

      await tester.tap(find.bySemanticsLabel('Remove from favorites').first);
      await tester.pumpAndSettle();

      expect(find.text('Product p1'), findsNothing);
      expect(find.text('Product p2'), findsOneWidget);
      expect(server.ids, {'p2'});
    });

    testWidgets('a refused removal keeps the product and says why', (
      tester,
    ) async {
      final server = await pumpScreen(
        tester,
        favorites: {'p1'},
        offered: [product('p1')],
      );
      server.error = const AppException(
        AppExceptionKind.server,
        message: 'Not now',
      );

      await tester.tap(find.bySemanticsLabel('Remove from favorites'));
      await tester.pumpAndSettle();

      expect(find.text('Product p1'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
    });

    testWidgets('a row opens the product', (tester) async {
      await pumpScreen(tester, favorites: {'p1'}, offered: [product('p1')]);

      await tester.tap(find.text('Product p1'));
      await tester.pumpAndSettle();

      expect(find.byType(ProductSheet), findsOneWidget);
    });
  });
}
