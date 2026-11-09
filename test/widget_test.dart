import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/token_storage.dart';
import 'package:gastro_suit/core/network/api_client.dart';
import 'package:gastro_suit/design_system/components/navigation/ds_bottom_navigation.dart';
import 'package:gastro_suit/features/home/home_screen/home_screen.dart';
import 'package:gastro_suit/features/order/order_screen/order_screen.dart';
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

    expect(find.byType(DSBottomNavigation), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text('Order'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderScreen), findsOneWidget);
  });
}
