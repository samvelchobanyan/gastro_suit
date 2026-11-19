import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/config/app_config.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/data/dto/order_dto.dart';
import 'package:gastro_suit/data/dto/wallet_dto.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/order.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/entities/wallet.dart';
import 'package:gastro_suit/domain/entities/wallet_movement.dart';
import 'package:gastro_suit/domain/state/menu_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/history/history_screen/history_screen.dart';
import 'package:gastro_suit/features/history/history_screen/order_history_controller.dart';
import 'package:gastro_suit/features/history/order_details_screen/order_details_screen.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../fakes/fake_checkout_repositories.dart';
import '../../fakes/fake_loyalty_repositories.dart';

/// A menu that never loads: the photos stay placeholders.
class _NoMenu extends BranchMenuController {
  _NoMenu(super.branchId);

  @override
  Future<Menu> build() async =>
      Menu(branchId: branchId, categories: const [], products: const []);
}

void main() {
  const language = ContentLanguage(current: 'en');

  OrderLine line(String name, {int quantity = 1, int price = 1000}) =>
      OrderLine(
        choice: ProductChoice(
          productId: 'p-$name',
          productName: name,
          size: const ChosenSize(id: 's', name: 'Large'),
          options: const [
            ChosenOption(id: 'o', groupId: 'g', name: 'Sugar', price: 0),
          ],
        ),
        quantity: quantity,
        unitPrice: price,
        total: price * quantity,
      );

  Order order(
    String id, {
    OrderStatus status = OrderStatus.collected,
    List<OrderLine>? lines,
    int tip = 0,
    int discount = 0,
    String? comment,
  }) {
    final products = lines ?? [line('Latte')];
    final subtotal = products.fold(0, (sum, l) => sum + l.total);
    return Order(
      id: id,
      status: status,
      number: 'GP-$id',
      branchId: 'b1',
      branchName: 'Northern Avenue',
      branchAddress: 'Northern Ave. 5',
      placedAt: DateTime(2026, 11, 16, 9, 12),
      lines: products,
      subtotal: subtotal,
      discount: discount,
      tip: tip,
      total: subtotal - discount + tip,
      comment: comment,
      isPaid: true,
    );
  }

  ProviderContainer containerWith(FakeOrderRepository orders) {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        orderRepositoryProvider.overrideWithValue(orders),
        contentLanguageProvider.overrideWith((ref) async => language),
      ],
    );
    addTearDown(container.dispose);
    // Kept alive as an open screen keeps it.
    container.listen(orderHistoryProvider, (_, _) {});
    return container;
  }

  group('the order history', () {
    test('leaves out the orders that were never paid for', () async {
      final orders = FakeOrderRepository()
        ..pages = [
          [
            order('1'),
            order('2', status: OrderStatus.awaitingPayment),
            order('3', status: OrderStatus.paymentFailed),
            order('4', status: OrderStatus.cancelled),
          ],
        ];
      final container = containerWith(orders);

      final history = await container.read(orderHistoryProvider.future);

      expect([for (final o in history.orders) o.id], ['1', '4']);
      expect(history.hasMore, isFalse);
    });

    test('reads the next page on demand, once at a time', () async {
      final orders = FakeOrderRepository()
        ..pages = [
          [order('1')],
          [order('2')],
        ];
      final container = containerWith(orders);
      await container.read(orderHistoryProvider.future);
      final controller = container.read(orderHistoryProvider.notifier);

      await Future.wait([controller.loadMore(), controller.loadMore()]);

      final history = container.read(orderHistoryProvider).value!;
      expect([for (final o in history.orders) o.id], ['1', '2']);
      expect(history.hasMore, isFalse);
      expect(orders.pagesRead, [1, 2]);

      await controller.loadMore();
      expect(orders.pagesRead, [1, 2]);
    });

    test('reads past a page with nothing to show', () async {
      final orders = FakeOrderRepository()
        ..pages = [
          [order('1')],
          [order('2', status: OrderStatus.paymentFailed)],
          [order('3')],
        ];
      final container = containerWith(orders);
      await container.read(orderHistoryProvider.future);

      await container.read(orderHistoryProvider.notifier).loadMore();

      final history = container.read(orderHistoryProvider).value!;
      expect([for (final o in history.orders) o.id], ['1', '3']);
      expect(orders.pagesRead, [1, 2, 3]);
    });

    test('a failed next page keeps the list and can be tried again', () async {
      final orders = FakeOrderRepository()
        ..pages = [
          [order('1')],
          [order('2')],
        ];
      final container = containerWith(orders);
      await container.read(orderHistoryProvider.future);
      final controller = container.read(orderHistoryProvider.notifier);

      orders.pageError = const AppException(AppExceptionKind.noConnection);
      await controller.loadMore();
      var history = container.read(orderHistoryProvider).value!;
      expect([for (final o in history.orders) o.id], ['1']);
      expect(history.moreFailed, isTrue);

      orders.pageError = null;
      await controller.loadMore();
      history = container.read(orderHistoryProvider).value!;
      expect([for (final o in history.orders) o.id], ['1', '2']);
      expect(history.moreFailed, isFalse);
    });
  });

  group('mapping', () {
    // As the dev server answers.
    test('an order has its lines, its amounts and its branch', () {
      final mapped = OrderDto.fromJson({
        'id': '178ba821',
        'status': 'completed',
        'paymentStatus': 'captured',
        'locationId': 'b1',
        'location': {
          'id': 'b1',
          'internalName': 'Coffee House — Ler Kamsar',
          'name': {'en': 'Ler Kamsar'},
          'address': {'en': 'Ler Kamsar St. 15/1, Yerevan'},
        },
        'comment': null,
        'itemsTotal': 3300,
        'discount': 300,
        'walletSpent': 1000,
        'walletReturned': 0,
        'totalToCharge': 2200,
        'tipAmount': 200,
        'posNumber': 'GP-4434',
        'createdAt': '2026-11-16T17:00:30.846Z',
        'items': [
          {
            'id': 'l1',
            'itemId': 'p1',
            'name': 'Latte',
            'quantity': 2,
            'unitPrice': 1650,
            'modifierPrice': 150,
            'total': 3300,
            'modifiersJson': [
              {'id': 'm1', 'name': 'Large', 'price': 0, 'groupId': 'size:p1'},
              {'id': 'm2', 'name': 'Syrup', 'price': 150, 'groupId': 'g1'},
            ],
          },
          {
            'id': 'l2',
            'itemId': null,
            'name': 'Gone',
            'quantity': 1,
            'unitPrice': 0,
            'modifierPrice': 0,
            'total': 0,
            'modifiersJson': null,
          },
        ],
      }).toDomain(language);

      expect(mapped.branchId, 'b1');
      expect(mapped.branchAddress, 'Ler Kamsar St. 15/1, Yerevan');
      expect(
        mapped.placedAt!.toUtc(),
        DateTime.utc(2026, 11, 16, 17, 0, 30, 846),
      );
      expect(mapped.subtotal, 3300);
      expect(mapped.discount, 300);
      expect(mapped.tip, 200);
      expect(mapped.total, 3200);
      expect(mapped.comment, isNull);
      expect(mapped.isPaid, isTrue);
      expect(mapped.isInHistory, isTrue);

      final latte = mapped.lines.first;
      expect(latte.choice.productId, 'p1');
      expect(latte.choice.size!.name, 'Large');
      expect(latte.choice.options.single.name, 'Syrup');
      expect(latte.quantity, 2);
      expect(latte.total, 3300);
      expect(mapped.lines.last.choice.productId, isEmpty);
      expect(mapped.lines.last.choice.productName, 'Gone');
    });

    test('only the money that did move is a movement', () {
      WalletMovement? of(String type, String status) =>
          WalletMovementDto.fromJson({
            'id': 'm',
            'type': type,
            'status': status,
            'amount': 500,
            'reference': null,
            'orderId': null,
            'createdAt': '2026-11-16T19:19:57.778Z',
          }).toDomain();

      expect(of('wallet_topup', 'success')!.kind, WalletMovementKind.topUp);
      expect(of('wallet_spend', 'success')!.kind, WalletMovementKind.spend);
      expect(of('wallet_topup', 'pending'), isNull);
      expect(of('wallet_topup', 'failed'), isNull);
      expect(of('something_new', 'success'), isNull);
    });
  });

  /// The History screen behind a router, so that an order can be opened.
  Future<void> pumpHistory(
    WidgetTester tester, {
    required List<Order> orders,
    List<WalletMovement> movements = const [],
  }) async {
    final server = FakeOrderRepository()..pages = [orders];
    final wallets = FakeWalletRepository(
      const Wallet(total: 0, ownTopUp: 0, gifts: 0, expiring: 0),
    )..movements = movements;
    final router = GoRouter(
      initialLocation: '/history',
      routes: [
        GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
        GoRoute(
          path: '/orders/:id',
          builder: (_, state) =>
              OrderDetailsScreen(orderId: state.pathParameters['id']!),
        ),
      ],
    );
    addTearDown(router.dispose);
    tester.view.physicalSize = const Size(360, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              apiBaseUrl: 'http://test',
              restaurantId: 'r1',
              mapTileUrl: '',
              mapAttribution: '',
              phoneCountryCode: '+374',
              phoneNumberLength: 8,
            ),
          ),
          orderRepositoryProvider.overrideWithValue(server),
          walletRepositoryProvider.overrideWithValue(wallets),
          contentLanguageProvider.overrideWith((ref) async => language),
          menuProvider('b1').overrideWith(() => _NoMenu('b1')),
        ],
        child: MaterialApp.router(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('the History screen', () {
    testWidgets('lists the orders by their first product', (tester) async {
      await pumpHistory(
        tester,
        orders: [
          order('1', lines: [line('Latte'), line('Muffin'), line('Tea')]),
          order('2', lines: [line('Americano', price: 700)]),
        ],
      );

      expect(find.text('Latte'), findsOneWidget);
      expect(find.text('Muffin'), findsNothing);
      // The two other products of the first order.
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('Order #GP-1'), findsOneWidget);
      expect(find.text('֏3,000'), findsOneWidget);
      expect(find.text('Americano'), findsOneWidget);
      expect(find.text('֏700'), findsOneWidget);
    });

    testWidgets('says so when there are no orders', (tester) async {
      await pumpHistory(tester, orders: const []);

      expect(find.text('No orders yet'), findsOneWidget);
    });

    testWidgets('the other tab lists what moved through the wallet', (
      tester,
    ) async {
      await pumpHistory(
        tester,
        orders: [order('1')],
        movements: [
          WalletMovement(
            id: 'm1',
            kind: WalletMovementKind.topUp,
            amount: 5000,
            at: DateTime(2026, 11, 14, 9, 10),
          ),
          WalletMovement(
            id: 'm2',
            kind: WalletMovementKind.spend,
            amount: 2250,
            at: DateTime(2026, 11, 12, 16, 40),
          ),
        ],
      );

      await tester.tap(find.text('Transactions'));
      await tester.pumpAndSettle();

      expect(find.text('Latte'), findsNothing);
      expect(find.text('Wallet top up'), findsOneWidget);
      expect(find.text('+֏5,000'), findsOneWidget);
      expect(find.text('Wallet payment'), findsOneWidget);
      expect(find.text('−֏2,250'), findsOneWidget);
    });

    testWidgets('a row opens the order in full', (tester) async {
      await pumpHistory(
        tester,
        orders: [
          order(
            '1',
            lines: [line('Latte', quantity: 2), line('Muffin', price: 500)],
            tip: 200,
            comment: 'Extra hot',
          ),
        ],
      );

      await tester.tap(find.text('Latte'));
      await tester.pumpAndSettle();

      expect(find.text('Order details'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('No. GP-1'), findsOneWidget);
      expect(find.text('Northern Avenue'), findsOneWidget);
      expect(find.text('Northern Ave. 5'), findsOneWidget);
      expect(find.text('Pickup'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Extra hot'), findsOneWidget);
      expect(find.text('Latte'), findsOneWidget);
      expect(find.text('Large · Sugar · ×2'), findsOneWidget);
      expect(find.text('Muffin'), findsOneWidget);
      // The lines, the tip and the two together.
      expect(find.text('֏2,500'), findsOneWidget);
      expect(find.text('֏200'), findsOneWidget);
      expect(find.text('֏2,700'), findsOneWidget);
      // Not shown: the API has nothing for them.
      expect(find.text('Guests'), findsNothing);
      expect(find.text('Received'), findsNothing);
      expect(find.text('Repeat order'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Back'));
      await tester.pumpAndSettle();
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('a cancelled order says so in its details', (tester) async {
      await pumpHistory(
        tester,
        orders: [order('1', status: OrderStatus.cancelled)],
      );

      await tester.tap(find.text('Latte'));
      await tester.pumpAndSettle();

      expect(find.text('Cancelled'), findsOneWidget);
    });
  });
}
