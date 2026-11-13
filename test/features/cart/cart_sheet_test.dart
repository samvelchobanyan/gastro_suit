import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_amount_field.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_stepper.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_time_picker.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_tip_selector.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_checkout_controller.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_sheet.dart';
import 'package:gastro_suit/features/cart/cart_sheet/widgets/cart_line_tile.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';

void main() {
  const latte = CartLine(
    id: 'line-latte',
    choice: ProductChoice(
      productId: 'latte',
      productName: 'Latte',
      size: ChosenSize(id: 'l', name: 'Large'),
      options: [
        ChosenOption(id: 'oat', groupId: 'milk', name: 'Oat milk', price: 250),
      ],
    ),
    quantity: 2,
    unitPrice: 2100,
    total: 4200,
    isAvailable: true,
  );
  const cake = CartLine(
    id: 'line-cake',
    choice: ProductChoice(
      productId: 'cake',
      productName: 'Cheesecake',
      options: [],
    ),
    quantity: 1,
    unitPrice: 2250,
    total: 2250,
    isAvailable: true,
  );

  Cart cartOf(List<CartLine> lines) => Cart(
    id: 'cart',
    branchId: 'b1',
    lines: lines,
    total: lines.fold(0, (sum, line) => sum + line.total),
  );

  /// The cart sheet open over a page. Answers with the providers and the
  /// cart behind it.
  Future<(ProviderContainer, FakeCartController)> openCart(
    WidgetTester tester, {
    required Cart? cart,
    bool acceptsTips = true,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeCart = FakeCartController(cart);
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeBranchProvider.overrideWith(
            (ref) async => Branch(
              id: 'b1',
              name: 'Northern Avenue',
              address: '',
              isTemporarilyClosed: false,
              acceptsTips: acceptsTips,
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
                  onPressed: () => showCart(context),
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

  Finder inLine(String lineName, Finder what) => find.descendant(
    of: find.ancestor(
      of: find.text(lineName),
      matching: find.byType(CartLineTile),
    ),
    matching: what,
  );

  testWidgets('shows the branch, the lines and the total', (tester) async {
    await openCart(tester, cart: cartOf([latte, cake]));

    expect(find.text('Basket'), findsOneWidget);
    expect(find.text('Northern Avenue'), findsOneWidget);
    expect(find.text('YOUR ORDER (3)'), findsOneWidget);
    // What was chosen, the size first, and the price of one.
    expect(find.text('Large · Oat milk'), findsOneWidget);
    expect(find.text('֏2,100'), findsOneWidget);
    expect(find.text('Cheesecake'), findsOneWidget);

    // Placing an order is not built: the button only shows the total.
    final order = tester.widget<DSButton>(find.byType(DSButton));
    expect(order.label, 'Order · ֏6,450');
    expect(order.onPressed, isNull);
  });

  testWidgets('the stepper of a line changes its quantity', (tester) async {
    final (_, cart) = await openCart(tester, cart: cartOf([latte, cake]));

    await tester.tap(
      inLine('Latte', find.bySemanticsLabel('Increase quantity')),
    );
    await tester.pumpAndSettle();

    expect(cart.quantities, [('line-latte', 3)]);
    expect(find.text('YOUR ORDER (4)'), findsOneWidget);
    expect(find.text('Order · ֏8,550'), findsOneWidget);
  });

  testWidgets('a line at one piece does not go lower', (tester) async {
    final (_, cart) = await openCart(tester, cart: cartOf([cake]));

    await tester.tap(find.bySemanticsLabel('Decrease quantity'));
    await tester.pumpAndSettle();

    expect(cart.quantities, isEmpty);
    expect(find.text('Cheesecake'), findsOneWidget);
  });

  testWidgets('the bin removes the line', (tester) async {
    final (_, cart) = await openCart(tester, cart: cartOf([latte, cake]));

    await tester.tap(
      inLine('Latte', find.bySemanticsLabel('Remove from the basket')),
    );
    await tester.pumpAndSettle();

    expect(cart.removed, ['line-latte']);
    expect(find.text('Latte'), findsNothing);
    expect(find.text('Order · ֏2,250'), findsOneWidget);
  });

  testWidgets('a refused change keeps the cart and says why', (tester) async {
    final (_, cart) = await openCart(tester, cart: cartOf([cake]));
    cart.changeError = const AppException(
      AppExceptionKind.server,
      message: 'No more of it can be ordered',
    );

    await tester.tap(find.bySemanticsLabel('Increase quantity'));
    await tester.pumpAndSettle();

    expect(find.text('No more of it can be ordered'), findsOneWidget);
    expect(find.text('YOUR ORDER (1)'), findsOneWidget);
  });

  testWidgets('a line the branch cannot make can only be removed', (
    tester,
  ) async {
    await openCart(
      tester,
      cart: cartOf([
        cake.copyWith(isAvailable: false, unavailableReason: 'out'),
      ]),
    );

    expect(find.text('Not available at this branch now'), findsOneWidget);
    expect(find.byType(DSStepper), findsNothing);
    expect(find.bySemanticsLabel('Remove from the basket'), findsOneWidget);
  });

  testWidgets('an empty cart says so and offers no time or tip', (
    tester,
  ) async {
    await openCart(tester, cart: cartOf(const []));

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('YOUR ORDER (0)'), findsOneWidget);
    expect(find.text('Add products'), findsOneWidget);
    expect(find.byType(DSTimePicker<DateTime?>), findsNothing);
    expect(find.byType(DSTipSelector), findsNothing);
  });

  testWidgets('a guest sees an empty cart', (tester) async {
    await openCart(tester, cart: null);

    expect(find.text('Your basket is empty'), findsOneWidget);
  });

  testWidgets('"Add products" closes the sheet', (tester) async {
    await openCart(tester, cart: cartOf([cake]));

    await tester.tap(find.text('Add products'));
    await tester.pumpAndSettle();

    expect(find.byType(CartSheet), findsNothing);
  });

  testWidgets('the time starts on ASAP and follows the tap', (tester) async {
    final (container, _) = await openCart(tester, cart: cartOf([cake]));
    final checkout = container.read(cartCheckoutProvider);
    DSTimePicker<DateTime?> picker() =>
        tester.widget(find.byType(DSTimePicker<DateTime?>));

    expect(find.text('ASAP'), findsOneWidget);
    expect(picker().value, isNull);
    // ASAP and the times worked out for now.
    expect(picker().slots, hasLength(checkout.slots.length + 1));

    await tester.tap(find.text(picker().slots[1].label));
    await tester.pump();

    expect(picker().value, checkout.slots.first);
    expect(container.read(cartCheckoutProvider).time, checkout.slots.first);
  });

  testWidgets('a tip is one of the amounts or an amount of the user\'s own', (
    tester,
  ) async {
    final (container, _) = await openCart(tester, cart: cartOf([cake]));
    await tester.scrollUntilVisible(
      find.text('No tip'),
      100,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(DSTipSelector), findsNWidgets(5));
    expect(find.byType(DSAmountField), findsNothing);

    await tester.tap(find.text('200֏'));
    await tester.pump();
    expect(container.read(cartCheckoutProvider).tip, 200);

    // The last tile is beyond the screen's edge: the row scrolls sideways.
    await tester.ensureVisible(find.text('Other'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pump();
    expect(container.read(cartCheckoutProvider).tip, 0);

    await tester.enterText(find.byType(DSAmountField), '450');
    await tester.pump();
    expect(container.read(cartCheckoutProvider).tip, 450);

    await tester.ensureVisible(find.text('No tip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No tip'));
    await tester.pump();
    expect(container.read(cartCheckoutProvider).tip, 0);
    expect(find.byType(DSAmountField), findsNothing);
  });

  testWidgets('a branch that takes no tips shows no tip part', (tester) async {
    await openCart(tester, cart: cartOf([cake]), acceptsTips: false);

    expect(find.text('TIP'), findsNothing);
    expect(find.byType(DSTipSelector), findsNothing);
  });
}
