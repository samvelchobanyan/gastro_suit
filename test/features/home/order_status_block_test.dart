import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/order.dart';
import 'package:gastro_suit/domain/state/active_orders_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/home/home_screen/widgets/order_status_block.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_checkout_repositories.dart';

void main() {
  Order order(
    OrderStatus status, {
    String id = 'order-1',
    String? number = 'GP-5106',
    DateTime? scheduledAt,
  }) => Order(
    id: id,
    status: status,
    number: number,
    branchName: 'Northern Avenue',
    scheduledAt: scheduledAt,
  );

  /// The block of a user whose latest orders are [recent]. Answers with the
  /// server, to move the orders on.
  Future<FakeOrderRepository> pumpBlock(
    WidgetTester tester,
    List<Order> recent, {
    AuthStatus auth = AuthStatus.signedIn,
  }) async {
    final orders = FakeOrderRepository()..recent = recent;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderRepositoryProvider.overrideWithValue(orders),
          authStatusProvider.overrideWithValue(auth),
          contentLanguageProvider.overrideWith(
            (ref) async => const ContentLanguage(current: 'en'),
          ),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: OrderStatusBlock()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return orders;
  }

  Color? colorOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style?.color;

  testWidgets('shows an order on its way: how, its number and its step', (
    tester,
  ) async {
    await pumpBlock(tester, [order(OrderStatus.preparing)]);

    expect(find.text('Order status'), findsOneWidget);
    expect(find.text('Pickup · ASAP'), findsOneWidget);
    expect(find.text('No. GP-5106'), findsOneWidget);
    // The steps behind, the step it is at, the step ahead.
    expect(colorOf(tester, 'Placed'), lightColors.textPrimary);
    expect(colorOf(tester, 'Accepted'), lightColors.textPrimary);
    expect(colorOf(tester, 'In process'), lightColors.textAccent);
    expect(colorOf(tester, 'Ready'), lightColors.textTertiary);
  });

  testWidgets('an order for a time says the time; no number, none shown', (
    tester,
  ) async {
    await pumpBlock(tester, [
      order(
        OrderStatus.placed,
        number: null,
        scheduledAt: DateTime(2026, 11, 16, 18, 30),
      ),
    ]);

    expect(find.text('Pickup · 18:30'), findsOneWidget);
    expect(find.textContaining('No.'), findsNothing);
    expect(colorOf(tester, 'Placed'), lightColors.textAccent);
  });

  testWidgets('every order on its way has its own card', (tester) async {
    await pumpBlock(tester, [
      order(OrderStatus.placed, id: 'order-2', number: 'GP-2'),
      order(OrderStatus.ready, id: 'order-1', number: 'GP-1'),
      order(OrderStatus.collected, id: 'order-0', number: 'GP-0'),
    ]);

    expect(find.text('Order status'), findsNWidgets(2));
    expect(find.text('No. GP-2'), findsOneWidget);
    expect(find.text('No. GP-1'), findsOneWidget);
    expect(find.text('No. GP-0'), findsNothing);
  });

  testWidgets('orders that are not on their way show nothing, and are not '
      'read again', (tester) async {
    final orders = await pumpBlock(tester, [
      order(OrderStatus.collected),
      order(OrderStatus.cancelled, id: 'order-2'),
      order(OrderStatus.awaitingPayment, id: 'order-3'),
      order(OrderStatus.paymentFailed, id: 'order-4'),
    ]);

    expect(find.text('Order status'), findsNothing);

    await tester.pump(ActiveOrdersController.refreshInterval * 3);
    expect(orders.recentReads, 1);
  });

  testWidgets('a guest has no orders to read', (tester) async {
    final orders = await pumpBlock(tester, [
      order(OrderStatus.placed),
    ], auth: AuthStatus.signedOut);

    expect(find.text('Order status'), findsNothing);
    expect(orders.recentReads, 0);
  });

  testWidgets('follows the order until it is handed over', (tester) async {
    final orders = await pumpBlock(tester, [order(OrderStatus.placed)]);
    expect(colorOf(tester, 'Placed'), lightColors.textAccent);

    orders.recent = [order(OrderStatus.ready)];
    await tester.pump(ActiveOrdersController.refreshInterval);
    await tester.pump();
    expect(colorOf(tester, 'Ready'), lightColors.textAccent);
    expect(orders.recentReads, 2);

    orders.recent = [order(OrderStatus.collected)];
    await tester.pump(ActiveOrdersController.refreshInterval);
    await tester.pump();
    expect(find.text('Order status'), findsNothing);
    expect(orders.recentReads, 3);

    // Nothing left to follow.
    await tester.pump(ActiveOrdersController.refreshInterval * 3);
    expect(orders.recentReads, 3);
  });

  testWidgets('a read that fails keeps the order shown and is made again', (
    tester,
  ) async {
    final orders = await pumpBlock(tester, [order(OrderStatus.placed)]);

    orders.recentError = const AppException(AppExceptionKind.noConnection);
    await tester.pump(ActiveOrdersController.refreshInterval);
    await tester.pump();
    expect(colorOf(tester, 'Placed'), lightColors.textAccent);

    orders
      ..recentError = null
      ..recent = [order(OrderStatus.accepted)];
    await tester.pump(ActiveOrdersController.refreshInterval);
    await tester.pump();
    expect(colorOf(tester, 'Accepted'), lightColors.textAccent);
  });
}
