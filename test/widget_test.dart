import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/token_storage.dart';
import 'package:gastro_suit/core/network/api_client.dart';
import 'package:gastro_suit/features/home/presentation/home/home_screen.dart';
import 'package:gastro_suit/features/order/presentation/order/order_screen.dart';
import 'package:gastro_suit/main.dart';

void main() {
  testWidgets('starts on Home and switches tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStorageProvider.overrideWithValue(TokenStorage()),
          apiClientProvider.overrideWithValue(
            ApiClient(baseUrl: 'http://test'),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.local_cafe_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(OrderScreen), findsOneWidget);
  });
}
