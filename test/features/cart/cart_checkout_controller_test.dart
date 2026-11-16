import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/order.dart';
import 'package:gastro_suit/domain/entities/payment_card.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/active_orders_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/payment_cards_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/cart/cart_sheet/cart_checkout_controller.dart';

import '../../fakes/fake_cart_controller.dart';
import '../../fakes/fake_checkout_repositories.dart';

/// A cart that counts how many times it was loaded.
class _CountingCart extends FakeCartController {
  _CountingCart(super.initial);

  var loads = 0;

  @override
  Future<Cart?> build() {
    loads++;
    return super.build();
  }
}

void main() {
  const first = PaymentCard(
    id: 'card-1',
    maskedNumber: '411111******1111',
    isDefault: false,
  );
  const second = PaymentCard(
    id: 'card-2',
    maskedNumber: '555555******2222',
    isDefault: true,
  );

  /// The checkout of a user with [cards] and a cart at `b1`.
  Future<
    (
      ProviderContainer,
      FakeOrderRepository,
      FakePaymentRepository,
      _CountingCart,
    )
  >
  setUp({List<PaymentCard> cards = const [first, second], Cart? cart}) async {
    final orders = FakeOrderRepository();
    final payments = FakePaymentRepository(cards);
    final fakeCart = _CountingCart(cart ?? cartAt('b1'));
    final container = ProviderContainer(
      overrides: [
        orderRepositoryProvider.overrideWithValue(orders),
        authStatusProvider.overrideWithValue(AuthStatus.signedIn),
        paymentRepositoryProvider.overrideWithValue(payments),
        paymentCardsProvider.overrideWith((ref) async => cards),
        cartProvider.overrideWith(() => fakeCart),
        contentLanguageProvider.overrideWith(
          (ref) async => const ContentLanguage(current: 'en'),
        ),
        activeBranchProvider.overrideWith(
          (ref) async => const Branch(
            id: 'b1',
            name: 'Northern Avenue',
            address: '',
            isTemporarilyClosed: false,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Kept alive as the open cart sheet keeps them.
    container.listen(cartCheckoutProvider, (_, _) {});
    container.listen(checkoutCardProvider, (_, _) {});
    await container.read(cartProvider.future);
    await container.read(paymentCardsProvider.future);
    return (container, orders, payments, fakeCart);
  }

  group('the card to pay with', () {
    test('is the default card until the user picks one', () async {
      final (container, _, _, _) = await setUp();
      expect(container.read(checkoutCardProvider), second);

      container.read(cartCheckoutProvider.notifier).selectCard('card-1');
      expect(container.read(checkoutCardProvider), first);
    });

    test('is the first card when none is the default', () async {
      final (container, _, _, _) = await setUp(cards: const [first]);
      expect(container.read(checkoutCardProvider), first);
    });

    test('is none for a user without cards', () async {
      final (container, _, _, _) = await setUp(cards: const []);
      expect(container.read(checkoutCardProvider), isNull);
    });
  });

  group('placing the order', () {
    test('sends the branch, the time and the tip', () async {
      final (container, orders, payments, cart) = await setUp();
      final controller = container.read(cartCheckoutProvider.notifier);
      final time = DateTime(2026, 11, 16, 18, 30);
      controller.selectTime(time);
      controller.selectTip(200);

      final order = await controller.placeOrder();

      expect(orders.placed, [('b1', time, 200)]);
      expect(order.status, OrderStatus.accepted);
      // Paid already: the card is not charged.
      expect(payments.paid, isEmpty);
      // The cart is loaded again: the order has emptied it.
      await container.read(cartProvider.future);
      expect(cart.loads, 2);
    });

    test('the orders on their way are read again', () async {
      final (container, orders, _, _) = await setUp();
      // Home is under the cart sheet, showing them.
      container.listen(activeOrdersProvider, (_, _) {});
      await container.read(activeOrdersProvider.future);
      expect(orders.recentReads, 1);

      await container.read(cartCheckoutProvider.notifier).placeOrder();
      await container.read(activeOrdersProvider.future);

      expect(orders.recentReads, 2);
    });

    test('pays an order left to be paid with the chosen card', () async {
      final (container, orders, payments, _) = await setUp();
      orders.awaitsPayment = true;
      final controller = container.read(cartCheckoutProvider.notifier);
      controller.selectCard('card-1');

      final order = await controller.placeOrder();

      expect(payments.paid, [('card-1', 'pay-1')]);
      expect(order.status, OrderStatus.accepted);
    });

    test('a declined card throws and keeps the cart', () async {
      final (container, orders, payments, cart) = await setUp();
      orders.awaitsPayment = true;
      payments.error = const AppException(
        AppExceptionKind.server,
        code: 'card_declined',
      );

      await expectLater(
        container.read(cartCheckoutProvider.notifier).placeOrder(),
        throwsA(isA<AppException>()),
      );
      expect(cart.loads, 1);
    });

    test('an order left to be paid cannot be paid without a card', () async {
      final (container, orders, payments, _) = await setUp(cards: const []);
      orders.awaitsPayment = true;

      await expectLater(
        container.read(cartCheckoutProvider.notifier).placeOrder(),
        throwsA(isA<AppException>()),
      );
      expect(payments.paid, isEmpty);
    });

    test('a refused order throws and keeps the cart', () async {
      final (container, orders, _, cart) = await setUp();
      orders.error = const AppException(
        AppExceptionKind.server,
        code: 'outside_hours',
      );

      await expectLater(
        container.read(cartCheckoutProvider.notifier).placeOrder(),
        throwsA(isA<AppException>()),
      );
      expect(cart.loads, 1);
    });

    test('an empty cart is not ordered', () async {
      final (container, orders, _, _) = await setUp(
        cart: const Cart(branchId: 'b1', lines: [], total: 0),
      );

      await expectLater(
        container.read(cartCheckoutProvider.notifier).placeOrder(),
        throwsA(isA<AppException>()),
      );
      expect(orders.placed, isEmpty);
    });
  });
}
