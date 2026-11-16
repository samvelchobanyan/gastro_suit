import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/config/app_config.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/loyalty_card.dart';
import 'package:gastro_suit/domain/entities/wallet.dart';
import 'package:gastro_suit/features/home/home_screen/widgets/loyalty_card_block.dart';
import 'package:gastro_suit/features/home/home_screen/widgets/wallet_block.dart';
import 'package:gastro_suit/features/loyalty/loyalty_card_sheet/loyalty_card_sheet.dart';
import 'package:gastro_suit/features/wallet/wallet_balance_sheet/wallet_balance_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../fakes/fake_loyalty_repositories.dart';

void main() {
  const card = LoyaltyCard(
    points: 1240,
    number: '3805642771084531',
    tier: 'Master',
  );
  const wallet = Wallet(
    total: 15000,
    ownTopUp: 10000,
    gifts: 5000,
    expiring: 0,
  );

  /// Home's loyalty card and wallet, one under the other, as Home has them.
  /// Answers with the server behind them.
  Future<(FakeLoyaltyRepository, FakeWalletRepository)> pumpBlocks(
    WidgetTester tester, {
    LoyaltyCard loyaltyCard = card,
    Wallet userWallet = wallet,
    AuthStatus auth = AuthStatus.signedIn,
    bool loyaltyOn = true,
    bool walletOn = true,
    Object? error,
  }) async {
    final loyalty = FakeLoyaltyRepository(loyaltyCard)..error = error;
    final wallets = FakeWalletRepository(userWallet)..error = error;
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        // A failed read is not made again behind the test's back.
        retry: (_, _) => null,
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              apiBaseUrl: 'http://test',
              restaurantId: 'r1',
              mapTileUrl: '',
              mapAttribution: '',
            ),
          ),
          authStatusProvider.overrideWithValue(auth),
          serverConfigRepositoryProvider.overrideWithValue(
            FakeServerConfigRepository(loyalty: loyaltyOn, wallet: walletOn),
          ),
          loyaltyRepositoryProvider.overrideWithValue(loyalty),
          walletRepositoryProvider.overrideWithValue(wallets),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Column(children: [LoyaltyCardBlock(), WalletBlock()]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (loyalty, wallets);
  }

  group('the loyalty card', () {
    testWidgets('shows the points, the tier and the card\'s code', (
      tester,
    ) async {
      await pumpBlocks(tester);

      expect(find.text('Loyalty points'), findsOneWidget);
      expect(find.text('1,240'), findsOneWidget);
      expect(find.text('Master'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('a card without a tier shows none', (tester) async {
      await pumpBlocks(
        tester,
        loyaltyCard: const LoyaltyCard(points: 0, number: '1'),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Master'), findsNothing);
    });

    testWidgets('opens the card for the cashier to scan', (tester) async {
      await pumpBlocks(tester);

      await tester.tap(find.byType(LoyaltyCardBlock));
      await tester.pumpAndSettle();

      expect(find.byType(LoyaltyCardSheet), findsOneWidget);
      expect(find.text('Scan at checkout to earn points'), findsOneWidget);
      expect(find.text('Available balance'), findsOneWidget);
      expect(find.text('1,240 pts'), findsOneWidget);
      // The code is the card's number.
      final code = tester.widget<QrImageView>(
        find.descendant(
          of: find.byType(LoyaltyCardSheet),
          matching: find.byType(QrImageView),
        ),
      );
      expect(code.size, lessThanOrEqualTo(200));
    });
  });

  group('the wallet', () {
    testWidgets('shows the balance; topping up is not offered yet', (
      tester,
    ) async {
      await pumpBlocks(tester);

      expect(find.text('Wallet balance'), findsOneWidget);
      expect(find.text('֏15,000'), findsOneWidget);
      final topUp = tester.widget<DSButton>(
        find.widgetWithText(DSButton, 'Top up'),
      );
      expect(topUp.onPressed, isNull);
    });

    testWidgets('opens what the balance is made of', (tester) async {
      await pumpBlocks(
        tester,
        userWallet: wallet.copyWith(
          expiring: 2000,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      );

      await tester.tap(find.text('֏15,000'));
      await tester.pumpAndSettle();

      final sheet = find.byType(WalletBalanceSheet);
      Finder inSheet(String text) =>
          find.descendant(of: sheet, matching: find.text(text));
      expect(inSheet('Total balance'), findsOneWidget);
      expect(inSheet('֏15,000'), findsOneWidget);
      expect(inSheet('Top-up balance'), findsOneWidget);
      expect(inSheet('No expiry · use anytime'), findsOneWidget);
      expect(inSheet('֏10,000'), findsOneWidget);
      expect(inSheet('From gift cards'), findsOneWidget);
      expect(inSheet('֏5,000 total'), findsOneWidget);
      expect(inSheet('Expiring balance'), findsOneWidget);
      expect(inSheet('֏2,000'), findsOneWidget);
      // A date a month away is not urgent.
      final date = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.textContaining('Expires ')),
      );
      expect(date.style?.color, lightColors.textTertiary);
    });

    testWidgets('a date within a week is shown as urgent', (tester) async {
      await pumpBlocks(
        tester,
        userWallet: wallet.copyWith(
          expiring: 2000,
          expiresAt: DateTime.now().add(const Duration(days: 3)),
        ),
      );

      await tester.tap(find.text('֏15,000'));
      await tester.pumpAndSettle();

      final date = tester.widget<Text>(find.textContaining('Expires '));
      expect(date.style?.color, lightColors.textError);
    });

    testWidgets('a wallet with no gifts and nothing to expire shows neither', (
      tester,
    ) async {
      await pumpBlocks(
        tester,
        userWallet: const Wallet(
          total: 3000,
          ownTopUp: 3000,
          gifts: 0,
          expiring: 0,
        ),
      );

      await tester.tap(find.text('֏3,000'));
      await tester.pumpAndSettle();

      expect(find.text('Top-up balance'), findsOneWidget);
      expect(find.text('From gift cards'), findsNothing);
      expect(find.text('Expiring balance'), findsNothing);
    });
  });

  group('neither is shown, and nothing is read', () {
    testWidgets('for a guest', (tester) async {
      final (loyalty, wallets) = await pumpBlocks(
        tester,
        auth: AuthStatus.signedOut,
      );

      expect(find.text('Loyalty points'), findsNothing);
      expect(find.text('Wallet balance'), findsNothing);
      expect(loyalty.reads, 0);
      expect(wallets.reads, 0);
    });

    testWidgets('when the instance has the module off', (tester) async {
      final (loyalty, wallets) = await pumpBlocks(
        tester,
        loyaltyOn: false,
        walletOn: false,
      );

      expect(find.text('Loyalty points'), findsNothing);
      expect(find.text('Wallet balance'), findsNothing);
      expect(loyalty.reads, 0);
      expect(wallets.reads, 0);
    });

    testWidgets('one module off leaves the other', (tester) async {
      await pumpBlocks(tester, walletOn: false);

      expect(find.text('Loyalty points'), findsOneWidget);
      expect(find.text('Wallet balance'), findsNothing);
    });
  });

  testWidgets('a failed read shows neither block', (tester) async {
    await pumpBlocks(
      tester,
      error: const AppException(AppExceptionKind.noConnection),
    );

    expect(find.text('Loyalty points'), findsNothing);
    expect(find.text('Wallet balance'), findsNothing);
  });
}
