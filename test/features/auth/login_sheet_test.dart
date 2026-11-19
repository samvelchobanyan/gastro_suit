import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/config/app_config.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_code_field.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/features/auth/login_sheet/login_sheet.dart';
import 'package:gastro_suit/features/auth/login_sheet/login_sheet_controller.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  const config = AppConfig(
    apiBaseUrl: 'http://test',
    restaurantId: 'r1',
    mapTileUrl: '',
    mapAttribution: '',
    phoneCountryCode: '+374',
    phoneNumberLength: 8,
  );

  group('the sign-in steps', () {
    (ProviderContainer, FakeAuthRepository) setUp() {
      final server = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          authRepositoryProvider.overrideWithValue(server),
        ],
      );
      addTearDown(container.dispose);
      // Keep the auto-dispose controller alive, as the sheet does.
      container.listen(loginSheetProvider, (_, _) {});
      return (container, server);
    }

    test('a code is sent to the whole number, then the code step', () async {
      final (container, server) = setUp();
      final controller = container.read(loginSheetProvider.notifier);

      controller.setPhone('7712345');
      expect(controller.isPhoneComplete, isFalse);
      await controller.sendCode();
      expect(server.requested, isEmpty);

      controller.setPhone('77123456');
      await controller.sendCode();

      expect(server.requested, ['+37477123456']);
      expect(container.read(loginSheetProvider).step, LoginStep.code);
    });

    test('a refused number stays on the phone step with the reason', () async {
      final (container, server) = setUp();
      server.requestError = const AppException(
        AppExceptionKind.server,
        code: 'otp_requests_exceeded',
      );
      final controller = container.read(loginSheetProvider.notifier)
        ..setPhone('77123456');

      await controller.sendCode();

      final state = container.read(loginSheetProvider);
      expect(state.step, LoginStep.phone);
      expect(state.error?.code, 'otp_requests_exceeded');
      expect(state.busy, isFalse);

      // Editing takes the reason away.
      controller.setPhone('7712345');
      expect(container.read(loginSheetProvider).error, isNull);
    });

    test('the code signs in at this organisation', () async {
      final (container, server) = setUp();
      final controller = container.read(loginSheetProvider.notifier)
        ..setPhone('77123456');
      await controller.sendCode();

      expect(await controller.verify('12345'), isFalse);
      expect(await controller.verify('123456'), isTrue);

      expect(server.signedIn, [('+37477123456', '123456', 'r1')]);
    });

    test('a refused code stays on the code step with the reason', () async {
      final (container, server) = setUp();
      server.signInError = const AppException(
        AppExceptionKind.unauthorized,
        code: 'otp_invalid',
      );
      final controller = container.read(loginSheetProvider.notifier)
        ..setPhone('77123456');
      await controller.sendCode();

      expect(await controller.verify('000000'), isFalse);
      expect(container.read(loginSheetProvider).error?.code, 'otp_invalid');
      expect(container.read(loginSheetProvider).step, LoginStep.code);

      controller.codeEdited();
      expect(container.read(loginSheetProvider).error, isNull);
    });

    test('changing the number goes back and keeps what was typed', () async {
      final (container, _) = setUp();
      final controller = container.read(loginSheetProvider.notifier)
        ..setPhone('77123456');
      await controller.sendCode();

      controller.changeNumber();

      final state = container.read(loginSheetProvider);
      expect(state.step, LoginStep.phone);
      expect(state.phone, '77123456');
    });
  });

  group('the sign-in sheet', () {
    /// A page with a button that opens the sheet. Answers with the server.
    Future<FakeAuthRepository> openSheet(WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final server = FakeAuthRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            authRepositoryProvider.overrideWithValue(server),
          ],
          child: MaterialApp(
            theme: buildAppTheme(lightColors),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showLoginSheet(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return server;
    }

    bool buttonEnabled(WidgetTester tester) =>
        tester.widget<DSButton>(find.byType(DSButton)).onPressed != null;

    Future<void> enterPhone(WidgetTester tester, String digits) async {
      await tester.enterText(find.byType(TextField), digits);
      await tester.pump();
    }

    testWidgets('asks for the number; the button waits for all of it', (
      tester,
    ) async {
      await openSheet(tester);

      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Send code'), findsOneWidget);
      expect(buttonEnabled(tester), isFalse);

      await enterPhone(tester, '7712345');
      expect(buttonEnabled(tester), isFalse);
      await enterPhone(tester, '77123456');
      expect(buttonEnabled(tester), isTrue);
    });

    testWidgets('the number takes digits only, and no more than it has', (
      tester,
    ) async {
      await openSheet(tester);

      await enterPhone(tester, '77 12-34x56 789');

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, '77123456');
    });

    testWidgets('the cross empties the number', (tester) async {
      await openSheet(tester);
      expect(find.bySemanticsLabel('Clear phone number'), findsNothing);

      await enterPhone(tester, '77123456');
      await tester.tap(find.bySemanticsLabel('Clear phone number'));
      await tester.pump();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, isEmpty);
      expect(buttonEnabled(tester), isFalse);
    });

    testWidgets('sending the code moves to the code step', (tester) async {
      final server = await openSheet(tester);
      await enterPhone(tester, '77123456');

      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();

      expect(server.requested, ['+37477123456']);
      expect(find.text('Enter code'), findsOneWidget);
      expect(
        find.textContaining(
          'Enter the 6 digit code sent to +374 77123456.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.byType(DSCodeField), findsOneWidget);
      expect(find.text('Verify'), findsOneWidget);
      expect(buttonEnabled(tester), isFalse);
    });

    testWidgets('the last digit of the code signs in and closes the sheet', (
      tester,
    ) async {
      final server = await openSheet(tester);
      await enterPhone(tester, '77123456');
      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pumpAndSettle();

      expect(server.signedIn, [('+37477123456', '123456', 'r1')]);
      expect(find.byType(LoginSheet), findsNothing);
    });

    testWidgets('a refused code is said, and the sheet stays', (tester) async {
      final server = await openSheet(tester);
      server.signInError = const AppException(
        AppExceptionKind.unauthorized,
        code: 'otp_invalid',
        message: 'That code is not right',
      );
      await enterPhone(tester, '77123456');
      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '000000');
      await tester.pumpAndSettle();

      expect(find.text('That code is not right'), findsOneWidget);
      expect(tester.widget<DSCodeField>(find.byType(DSCodeField)).error, true);
      expect(find.byType(LoginSheet), findsOneWidget);

      // Typing again takes the refusal away.
      await tester.enterText(find.byType(TextField), '00000');
      await tester.pumpAndSettle();
      expect(find.text('That code is not right'), findsNothing);
    });

    testWidgets('the code is sent again, and that is said for a moment', (
      tester,
    ) async {
      final server = await openSheet(tester);
      await enterPhone(tester, '77123456');
      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend code'));
      await tester.pump();
      await tester.pump();

      expect(server.requested, hasLength(2));
      expect(find.text('Sent'), findsOneWidget);
      expect(find.text('Resend code'), findsNothing);

      await tester.pump(LoginSheetController.resentNotice);
      expect(find.text('Resend code'), findsOneWidget);
    });

    testWidgets('"Change number" goes back to the number as it was', (
      tester,
    ) async {
      await openSheet(tester);
      await enterPhone(tester, '77123456');
      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change number'));
      await tester.pumpAndSettle();

      expect(find.text('Log in'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, '77123456');
      expect(buttonEnabled(tester), isTrue);
    });

    testWidgets('the close button closes the sheet', (tester) async {
      await openSheet(tester);

      await tester.tap(find.bySemanticsLabel('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginSheet), findsNothing);
    });
  });
}
