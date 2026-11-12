import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/features/menu/widgets/menu_product_card.dart';
import 'package:gastro_suit/features/order/order_screen/widgets/products_tab.dart';
import 'package:gastro_suit/features/shared_widgets/product_card.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

class _FakeMenu extends BranchMenuController {
  _FakeMenu(this.menu) : super(menu.branchId);

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  Product product(String id, {bool featured = false}) => Product(
    id: id,
    categoryId: 'sweets',
    name: id,
    price: 1250,
    isAvailable: true,
    isFeatured: featured,
    sizes: const [],
    optionGroups: const [],
  );

  Future<void> pumpTab(WidgetTester tester, List<Product> products) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final menu = Menu(
      branchId: 'b1',
      categories: const [MenuCategory(id: 'sweets', name: 'Sweets')],
      products: products,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeBranchProvider.overrideWith(
            (ref) async => const Branch(
              id: 'b1',
              name: 'Northern Avenue',
              address: '',
              isTemporarilyClosed: false,
            ),
          ),
          menuProvider('b1').overrideWith(() => _FakeMenu(menu)),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ProductsTab()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the featured products over the active branch menu', (
    tester,
  ) async {
    await pumpTab(tester, [product('muffin', featured: true), product('cake')]);

    expect(find.text('Featured products'), findsOneWidget);
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.byType(MenuProductCard), findsNWidgets(2));
  });

  testWidgets('without featured products the rail is not shown', (
    tester,
  ) async {
    await pumpTab(tester, [product('muffin'), product('cake')]);

    expect(find.text('Featured products'), findsNothing);
    expect(find.byType(MenuProductCard), findsNWidgets(2));
  });
}
