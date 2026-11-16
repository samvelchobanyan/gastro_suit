import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/order.dart';
import 'package:gastro_suit/features/cart/order_success_screen/order_success_screen.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  /// An app on its Order tab with a button that shows [order] as placed.
  Future<void> open(WidgetTester tester, Order order) async {
    final router = GoRouter(
      initialLocation: '/order',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const Text('home tab')),
        GoRoute(
          path: '/order',
          builder: (context, _) => TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<void>(
                builder: (_) => OrderSuccessScreen(order: order),
              ),
            ),
            child: const Text('place'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: buildAppTheme(lightColors),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.tap(find.text('place'));
    await tester.pumpAndSettle();
  }

  testWidgets('says where and when to collect the order', (tester) async {
    await open(
      tester,
      Order(
        id: 'order-1',
        status: OrderStatus.accepted,
        branchName: 'Northern Avenue',
        scheduledAt: DateTime(2026, 11, 16, 18, 30),
      ),
    );

    expect(
      find.text('Your order has been successfully placed!'),
      findsOneWidget,
    );
    expect(find.text('Pickup location'), findsOneWidget);
    expect(find.text('Northern Avenue'), findsOneWidget);
    expect(find.text('Pickup time'), findsOneWidget);
    expect(find.text('18:30'), findsOneWidget);
  });

  testWidgets('an order for as soon as possible says so', (tester) async {
    await open(
      tester,
      const Order(
        id: 'order-1',
        status: OrderStatus.accepted,
        branchName: 'Northern Avenue',
      ),
    );

    expect(find.text('ASAP'), findsOneWidget);
  });

  testWidgets('"Track order" closes the screen and opens the Home tab', (
    tester,
  ) async {
    await open(
      tester,
      const Order(
        id: 'order-1',
        status: OrderStatus.accepted,
        branchName: 'Northern Avenue',
      ),
    );

    await tester.tap(find.text('Track order'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderSuccessScreen), findsNothing);
    expect(find.text('home tab'), findsOneWidget);
    expect(find.text('place'), findsNothing);
  });
}
