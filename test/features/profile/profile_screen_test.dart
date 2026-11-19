import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/app_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_toggle.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/payment_card.dart';
import 'package:gastro_suit/domain/entities/profile.dart';
import 'package:gastro_suit/domain/state/payment_cards_state.dart';
import 'package:gastro_suit/features/profile/profile_screen/profile_screen.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../fakes/fake_auth_repository.dart';
import '../../fakes/fake_favorites_repository.dart';
import '../../fakes/fake_profile_repository.dart';

void main() {
  const aram = Profile(
    name: 'Aram',
    surname: 'Shahinyan',
    phone: '+374 91 234 567',
  );

  late AppLanguageStorage language;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    language = AppLanguageStorage();
  });

  /// The Profile tab in an app that follows the chosen language, as the
  /// real one does. Answers with the server behind it.
  Future<(FakeProfileRepository, FakeAuthRepository)> pumpScreen(
    WidgetTester tester, {
    Profile profile = aram,
    AuthStatus auth = AuthStatus.signedIn,
    List<PaymentCard> cards = const [
      PaymentCard(
        id: 'card-1',
        maskedNumber: '411111******4556',
        isDefault: true,
      ),
    ],
    Set<String> favorites = const {'p-1', 'p-2', 'p-3'},
    Object? error,
  }) async {
    final profiles = FakeProfileRepository(profile)..error = error;
    final sessions = FakeAuthRepository();
    // Tall enough to build the whole list.
    tester.view.physicalSize = const Size(360, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        // A failed read is not made again behind the test's back.
        retry: (_, _) => null,
        overrides: [
          authStatusProvider.overrideWithValue(auth),
          appLanguageStorageProvider.overrideWithValue(language),
          profileRepositoryProvider.overrideWithValue(profiles),
          authRepositoryProvider.overrideWithValue(sessions),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(favorites),
          ),
          paymentCardsProvider.overrideWith((ref) async => cards),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            theme: buildAppTheme(lightColors),
            locale: Locale(ref.watch(appLanguageProvider)),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: ProfileScreen()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (profiles, sessions);
  }

  group('a signed-in user', () {
    testWidgets('sees themselves, the invite and the list', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Aram Shahinyan'), findsOneWidget);
      expect(find.text('+374 91 234 567'), findsOneWidget);
      expect(find.text('AS'), findsOneWidget);
      expect(find.text('Invite a friend'), findsOneWidget);
      expect(find.text('Bank cards'), findsOneWidget);
      expect(find.text('**** 4556'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('3 products'), findsOneWidget);
      expect(find.text('Push notifications'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete account'), findsOneWidget);
      expect(find.text('Terms & conditions'), findsOneWidget);
      // Not shown: no data for the status, no use for the switch.
      expect(find.text('Geolocation'), findsNothing);
      expect(find.text('Sign in'), findsNothing);
    });

    testWidgets('without saved cards the row names none', (tester) async {
      await pumpScreen(tester, cards: const []);

      expect(find.text('Bank cards'), findsOneWidget);
      expect(find.textContaining('****'), findsNothing);
    });

    testWidgets('without a name is shown by what they sign in with', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        profile: const Profile(name: '', surname: '', email: 'test@test.com'),
        favorites: const {},
      );

      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('0 products'), findsOneWidget);
    });

    testWidgets('a failed load offers to try again', (tester) async {
      final (profiles, _) = await pumpScreen(
        tester,
        error: const AppException(AppExceptionKind.noConnection),
      );
      expect(find.text('Aram Shahinyan'), findsNothing);

      profiles.error = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('Aram Shahinyan'), findsOneWidget);
    });

    testWidgets('the switch of push notifications moves', (tester) async {
      await pumpScreen(tester);
      expect(tester.widget<DSToggle>(find.byType(DSToggle)).value, isTrue);

      await tester.tap(find.byType(DSToggle));
      await tester.pumpAndSettle();

      expect(tester.widget<DSToggle>(find.byType(DSToggle)).value, isFalse);
    });

    testWidgets('signs out', (tester) async {
      final (_, sessions) = await pumpScreen(tester);

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(sessions.logouts, 1);
    });

    testWidgets('deletes the account only after confirming', (tester) async {
      final (profiles, _) = await pumpScreen(tester);

      await tester.tap(find.text('Delete account'));
      await tester.pumpAndSettle();
      expect(find.text('Delete account?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(profiles.deletions, 0);

      await tester.tap(find.text('Delete account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(profiles.deletions, 1);
    });

    testWidgets('a refused deletion is said', (tester) async {
      final (profiles, _) = await pumpScreen(tester);
      profiles.deleteError = const AppException(
        AppExceptionKind.server,
        message: 'Not now',
      );

      await tester.tap(find.text('Delete account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(profiles.deletions, 0);
      expect(find.text('Not now'), findsOneWidget);
    });
  });

  testWidgets('a guest sees the sign-in, the language and the links', (
    tester,
  ) async {
    await pumpScreen(tester, auth: AuthStatus.signedOut);

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Terms & conditions'), findsOneWidget);
    expect(find.text('Invite a friend'), findsNothing);
    expect(find.text('Bank cards'), findsNothing);
    expect(find.text('Logout'), findsNothing);
    expect(find.text('Delete account'), findsNothing);
  });

  testWidgets('a chosen language changes the app at once and is kept', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('Bank cards'), findsOneWidget);

    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();

    expect(find.text('Банковские карты'), findsOneWidget);
    expect(find.text('3 товара'), findsOneWidget);
    expect(find.text('Bank cards'), findsNothing);

    final restarted = AppLanguageStorage();
    await restarted.init();
    expect(restarted.code, 'ru');
  });
}
