import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_amount_field.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_payment_method.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_radio.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_stepper.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_time_picker.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_tip_selector.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/payment_card.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/domain/state/payment_cards_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_checkout_controller.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_sheet.dart';
import 'package:gastro_suit/features/cart/cart_sheet/widgets/cart_line_tile.dart';
import 'package:gastro_suit/features/cart/order_success_screen/order_success_screen.dart';
import 'package:gastro_suit/features/cart/payment_method_sheet/payment_method_sheet.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_cart_controller.dart';
import '../../fakes/fake_checkout_repositories.dart';

class _FakeMenu extends BranchMenuController {
  _FakeMenu(this.menu) : super('b1');

  final Menu menu;

  @override
  Future<Menu> build() async => menu;
}

void main() {
  const latte = CartLine(
    id: 'line-latte',
    choice: ProductChoice(
      productId: 'latte',
      productName: 'Latte',
      size: ChosenSize(id: 'l', name: 'Large'),
      options: [
        ChosenOption(id: 'oat', groupId: 'milk', name: 'Oat milk', price: 250),
        ChosenOption(
          id: 'sugar',
          groupId: 'sweetener',
          name: 'Sugar',
          price: 0,
          quantity: 2,
        ),
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

  const visa = PaymentCard(
    id: 'card-1',
    maskedNumber: '411111******1111',
    isDefault: false,
  );
  const master = PaymentCard(
    id: 'card-2',
    maskedNumber: '555555******2222',
    isDefault: true,
  );

  /// The server the last opened cart places its orders at.
  late FakeOrderRepository orders;

  /// The cart sheet open over a page. Answers with the providers and the
  /// cart behind it.
  Future<(ProviderContainer, FakeCartController)> openCart(
    WidgetTester tester, {
    required Cart? cart,
    bool acceptsTips = true,
    List<Product> menu = const [],
    List<PaymentCard> cards = const [visa, master],
  }) async {
    orders = FakeOrderRepository();
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
          paymentCardsProvider.overrideWith((ref) async => cards),
          orderRepositoryProvider.overrideWithValue(orders),
          paymentRepositoryProvider.overrideWithValue(
            FakePaymentRepository(cards),
          ),
          contentLanguageProvider.overrideWith(
            (ref) async => const ContentLanguage(current: 'en'),
          ),
          menuProvider('b1').overrideWith(
            () => _FakeMenu(
              Menu(branchId: 'b1', categories: const [], products: menu),
            ),
          ),
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
    // What was chosen, the size first, an option taken twice with its
    // count, and the price of one.
    expect(find.text('Large · Oat milk · Sugar ×2'), findsOneWidget);
    expect(find.text('֏2,100'), findsOneWidget);
    expect(find.text('Cheesecake'), findsOneWidget);

    final order = tester.widget<DSButton>(find.byType(DSButton));
    expect(order.label, 'Order · ֏6,450');
    expect(order.onPressed, isNotNull);
  });

  testWidgets('the order is paid with the default card or a picked one', (
    tester,
  ) async {
    await openCart(tester, cart: cartOf([cake]));
    await tester.scrollUntilVisible(
      find.text('PAYMENT METHOD'),
      100,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Card •••• 2222'), findsOneWidget);

    await tester.tap(find.text('Card •••• 2222'));
    await tester.pumpAndSettle();
    final list = find.byType(PaymentMethodSheet);
    expect(find.text('Choose payment method'), findsOneWidget);
    final rows = tester.widgetList<DSPaymentMethod>(
      find.descendant(of: list, matching: find.byType(DSPaymentMethod)),
    );
    expect(
      [for (final row in rows) row.name],
      ['Card •••• 1111', 'Card •••• 2222', 'New card'],
    );
    // Paying with a new card is not built: its row takes no taps.
    expect(rows.last.onTap, isNull);

    await tester.tap(find.text('Card •••• 1111'));
    await tester.pumpAndSettle();
    expect(list, findsNothing);
    expect(find.text('Card •••• 1111'), findsOneWidget);
    expect(find.text('Card •••• 2222'), findsNothing);
  });

  testWidgets('a user without cards sees a new card as the way to pay', (
    tester,
  ) async {
    await openCart(tester, cart: cartOf([cake]), cards: const []);
    await tester.scrollUntilVisible(
      find.text('PAYMENT METHOD'),
      100,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('New card'), findsOneWidget);
    expect(tester.widget<DSButton>(find.byType(DSButton)).onPressed, isNotNull);
  });

  testWidgets('the order button places the order and shows it was placed', (
    tester,
  ) async {
    await openCart(tester, cart: cartOf([cake]));
    await tester.tap(find.text('200֏'));
    await tester.pump();

    await tester.tap(find.text('Order · ֏2,250'));
    await tester.pumpAndSettle();

    // For as soon as possible, with the tip chosen.
    expect(orders.placed, [('b1', null, 200)]);
    expect(find.byType(CartSheet), findsNothing);
    expect(find.byType(OrderSuccessScreen), findsOneWidget);
    expect(find.text('Northern Avenue'), findsOneWidget);
    expect(find.text('ASAP'), findsOneWidget);
  });

  testWidgets('a refused order keeps the cart and says why', (tester) async {
    await openCart(tester, cart: cartOf([cake]));
    orders.error = const AppException(
      AppExceptionKind.server,
      message: 'The branch is closed now',
    );

    await tester.tap(find.text('Order · ֏2,250'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderSuccessScreen), findsNothing);
    expect(find.byType(CartSheet), findsOneWidget);
    expect(find.text('The branch is closed now'), findsOneWidget);
    expect(find.text('Cheesecake'), findsOneWidget);
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
    expect(find.bySemanticsLabel('Change the choice'), findsNothing);
    expect(find.bySemanticsLabel('Remove from the basket'), findsOneWidget);
  });

  testWidgets('the pencil opens the product on what the line holds', (
    tester,
  ) async {
    final (_, cart) = await openCart(
      tester,
      cart: cartOf([latte]),
      menu: const [
        Product(
          id: 'latte',
          categoryId: 'c1',
          name: 'Latte',
          price: 1450,
          isAvailable: true,
          isFeatured: false,
          sizes: [
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
          optionGroups: [
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
                  isDefault: true,
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
            ProductOptionGroup(
              id: 'sweetener',
              name: 'Sweetener',
              minSelected: 0,
              options: [
                ProductOption(
                  id: 'sugar',
                  name: 'Sugar',
                  price: 0,
                  isAvailable: true,
                  isDefault: false,
                  maxQuantity: 5,
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.tap(find.bySemanticsLabel('Change the choice'));
    await tester.pumpAndSettle();

    final sheet = find.byType(ProductSheet);
    expect(sheet, findsOneWidget);
    // The line's size, milk and sugar, not the defaults; two pieces.
    final radios = tester.widgetList<DSRadio>(
      find.descendant(of: sheet, matching: find.byType(DSRadio)),
    );
    expect([for (final radio in radios) radio.selected], [false, true]);
    final steppers = tester.widgetList<DSStepper>(
      find.descendant(of: sheet, matching: find.byType(DSStepper)),
    );
    // Sugar twice, and two of the product.
    expect([for (final stepper in steppers) stepper.value], [2, 2]);

    // Large with oat milk, twice: the button saves, nothing is added from
    // here.
    final save = tester.widget<DSButton>(
      find.descendant(of: sheet, matching: find.byType(DSButton)),
    );
    expect(save.label, 'Save · ֏4,200');
    expect(find.textContaining('Add ·'), findsNothing);

    // Nothing was changed: saving closes the sheet and asks for nothing.
    await tester.tap(find.text('Save · ֏4,200'));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    expect(cart.changedLines, isEmpty);

    // A changed choice goes to the line, with its quantity.
    await tester.tap(find.bySemanticsLabel('Change the choice'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: sheet, matching: find.text('Small')));
    await tester.pump();
    await tester.tap(find.text('Save · ֏3,400'));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    final (lineId, choice, quantity) = cart.changedLines.single;
    expect(lineId, 'line-latte');
    expect(choice.size?.id, 's');
    expect(
      [for (final option in choice.options) (option.id, option.quantity)],
      [('oat', 1), ('sugar', 2)],
    );
    expect(quantity, 2);
    expect(find.text('Small · Oat milk · Sugar ×2'), findsOneWidget);

    // A refused save leaves the sheet open and says why.
    cart.changeError = const AppException(
      AppExceptionKind.server,
      message: 'Not sold in this size now',
    );
    await tester.tap(find.bySemanticsLabel('Change the choice'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: sheet, matching: find.text('Large')));
    await tester.pump();
    await tester.tap(find.text('Save · ֏4,200'));
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);
    expect(find.text('Not sold in this size now'), findsOneWidget);
    expect(cart.changedLines, hasLength(1));
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

  testWidgets('the keyboard covers neither the tip field nor the order bar', (
    tester,
  ) async {
    await openCart(tester, cart: cartOf([cake]));
    await tester.scrollUntilVisible(
      find.text('No tip'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Other'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();

    // The keyboard takes the screen from 500 down.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.showKeyboard(find.byType(DSAmountField));
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byType(DSAmountField)).bottom,
      lessThanOrEqualTo(500),
    );
    expect(
      tester.getRect(find.byType(DSButton)).bottom,
      lessThanOrEqualTo(500),
    );
  });

  testWidgets('a branch that takes no tips shows no tip part', (tester) async {
    await openCart(tester, cart: cartOf([cake]), acceptsTips: false);

    expect(find.text('TIP'), findsNothing);
    expect(find.byType(DSTipSelector), findsNothing);
  });
}
