import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/config/app_config.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/navigation/main_shell.dart';
import 'package:gastro_suit/design_system/components/navigation/ds_bottom_navigation.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/loyalty_card.dart';
import 'package:gastro_suit/features/auth/login_sheet/login_sheet.dart';
import 'package:gastro_suit/features/loyalty/loyalty_card_sheet/loyalty_card_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../fakes/fake_auth_repository.dart';
import '../../fakes/fake_loyalty_repositories.dart';

void main() {
  /// The shell over four plain tabs. Each tab says its name and the bottom
  /// padding it was given.
  Future<void> pumpShell(
    WidgetTester tester, {
    AuthStatus auth = AuthStatus.signedIn,
    bool loyaltyOn = true,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    StatefulShellBranch tab(String name) => StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/$name',
          builder: (context, _) => Text(
            '$name tab, ${MediaQuery.paddingOf(context).bottom} under it',
          ),
        ),
      ],
    );
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => MainShell(shell: shell),
          branches: [tab('home'), tab('order'), tab('gifts'), tab('profile')],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
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
          authStatusProvider.overrideWithValue(auth),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          serverConfigRepositoryProvider.overrideWithValue(
            FakeServerConfigRepository(loyalty: loyaltyOn),
          ),
          loyaltyRepositoryProvider.overrideWithValue(
            FakeLoyaltyRepository(
              const LoyaltyCard(points: 1240, number: '3805642771084531'),
            ),
          ),
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

  DSBottomNavigation nav(WidgetTester tester) =>
      tester.widget(find.byType(DSBottomNavigation));

  testWidgets('a tab goes under the navigation and is told its height', (
    tester,
  ) async {
    await pumpShell(tester);

    // The pill and the margin under it.
    expect(find.text('home tab, 64.0 under it'), findsOneWidget);
    expect(nav(tester).currentIndex, 0);
  });

  testWidgets('an item shows its tab', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();

    expect(find.textContaining('profile tab'), findsOneWidget);
    // The fifth item: the loyalty card stands before Gifts and Profile.
    expect(nav(tester).currentIndex, 4);
  });

  testWidgets('the loyalty card opens over the tab, which stays', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(find.bySemanticsLabel('Order'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Show loyalty card'));
    await tester.pumpAndSettle();

    expect(find.byType(LoyaltyCardSheet), findsOneWidget);
    expect(find.textContaining('order tab'), findsOneWidget);
    expect(nav(tester).currentIndex, 1);
  });

  testWidgets('a guest is asked to sign in instead of the card', (
    tester,
  ) async {
    await pumpShell(tester, auth: AuthStatus.signedOut);

    await tester.tap(find.bySemanticsLabel('Show loyalty card'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginSheet), findsOneWidget);
    expect(find.byType(LoyaltyCardSheet), findsNothing);
  });

  testWidgets('without a loyalty programme there are the four tabs only', (
    tester,
  ) async {
    await pumpShell(tester, loyaltyOn: false);

    expect(nav(tester).items, hasLength(4));
    expect(find.bySemanticsLabel('Show loyalty card'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.textContaining('profile tab'), findsOneWidget);
    expect(nav(tester).currentIndex, 3);
  });
}
