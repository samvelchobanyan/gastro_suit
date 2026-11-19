import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/city.dart';
import 'package:gastro_suit/domain/entities/profile.dart';
import 'package:gastro_suit/domain/state/cities_state.dart';
import 'package:gastro_suit/domain/state/profile_state.dart';
import 'package:gastro_suit/features/profile/edit_profile_screen/edit_profile_controller.dart';
import 'package:gastro_suit/features/profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import '../../fakes/fake_profile_repository.dart';

class _Cities extends CitiesController {
  @override
  Future<List<City>> build() async => const [
    City(id: 'c-yerevan', name: 'Yerevan', districts: []),
    City(id: 'c-gyumri', name: 'Gyumri', districts: []),
  ];
}

/// The phone's camera and gallery: gives [picked] and remembers where it
/// was asked to take a picture from.
class _FakePicker extends ImagePickerPlatform {
  XFile? picked;
  ImageSource? asked;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    asked = source;
    return picked;
  }
}

void main() {
  final aram = Profile(
    name: 'Aram',
    surname: 'Shahinyan',
    phone: '+374 91 234 567',
    birthday: DateTime(1995, 3, 12),
    city: 'c-yerevan',
    gender: Gender.male,
  );

  group('the draft', () {
    test('a month has its own days; February of no year has 29', () {
      expect(const ProfileDraft().daysInMonth, 31);
      expect(const ProfileDraft(month: 4).daysInMonth, 30);
      expect(const ProfileDraft(month: 2).daysInMonth, 29);
      expect(const ProfileDraft(month: 2, year: 2023).daysInMonth, 28);
      expect(const ProfileDraft(month: 2, year: 2024).daysInMonth, 29);
    });

    test('a birthday is whole when chosen in full or not at all', () {
      expect(const ProfileDraft().birthdayIsWhole, isTrue);
      expect(const ProfileDraft(day: 1).birthdayIsWhole, isFalse);
      expect(const ProfileDraft(day: 1, month: 2).birthdayIsWhole, isFalse);
      const whole = ProfileDraft(day: 1, month: 2, year: 2000);
      expect(whole.birthdayIsWhole, isTrue);
      expect(whole.birthday, DateTime(2000, 2, 1));
    });
  });

  group('the form', () {
    Future<(ProviderContainer, FakeProfileRepository)> form(
      Profile profile,
    ) async {
      final server = FakeProfileRepository(profile);
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          authStatusProvider.overrideWithValue(AuthStatus.signedIn),
          profileRepositoryProvider.overrideWithValue(server),
        ],
      );
      addTearDown(container.dispose);
      await container.read(profileProvider.future);
      // Kept alive as the screen keeps it.
      container.listen(editProfileProvider, (_, _) {});
      return (container, server);
    }

    test('opens with the profile and has nothing to save', () async {
      final (container, _) = await form(aram);
      final state = container.read(editProfileProvider);

      expect(state.draft.name, 'Aram');
      expect(state.draft.day, 12);
      expect(state.draft.month, 3);
      expect(state.draft.year, 1995);
      expect(state.draft.city, 'c-yerevan');
      expect(state.draft.gender, Gender.male);
      expect(state.canSave, isFalse);
    });

    test('spaces around a name are not a change', () async {
      final (container, _) = await form(aram);
      final controller = container.read(editProfileProvider.notifier);

      controller.setName(' Aram ');
      expect(container.read(editProfileProvider).canSave, isFalse);

      controller.setName('Ara');
      expect(container.read(editProfileProvider).canSave, isTrue);
    });

    test('a day the new month does not have is no longer chosen', () async {
      final (container, _) = await form(
        aram.copyWith(birthday: DateTime(1995, 3, 31)),
      );
      final controller = container.read(editProfileProvider.notifier);

      controller.setMonth(4);

      final state = container.read(editProfileProvider);
      expect(state.draft.day, isNull);
      // A birthday in part cannot be saved.
      expect(state.canSave, isFalse);

      controller.setDay(30);
      expect(container.read(editProfileProvider).canSave, isTrue);
    });

    test('saving sends the draft and updates the shared profile', () async {
      final (container, server) = await form(aram);
      final controller = container.read(editProfileProvider.notifier);
      controller
        ..setName(' Aramik ')
        ..setYear(1996)
        ..setCity('c-gyumri')
        ..setGender(Gender.female);

      expect(await controller.save(), isTrue);

      final saved = container.read(profileProvider).value!;
      expect(saved.name, 'Aramik');
      expect(saved.surname, 'Shahinyan');
      expect(saved.birthday, DateTime(1996, 3, 12));
      expect(saved.city, 'c-gyumri');
      expect(saved.gender, Gender.female);
      expect(server.updates, 1);
      // Saved: nothing is left to save.
      expect(container.read(editProfileProvider).canSave, isFalse);
    });

    test('a refused save keeps the draft and the reason', () async {
      final (container, server) = await form(aram);
      server.changeError = const AppException(AppExceptionKind.noConnection);
      final controller = container.read(editProfileProvider.notifier)
        ..setName('Ara');

      expect(await controller.save(), isFalse);

      final state = container.read(editProfileProvider);
      expect(state.error, isA<AppException>());
      expect(state.draft.name, 'Ara');
      expect(state.canSave, isTrue);
      expect(container.read(profileProvider).value!.name, 'Aram');
    });

    test('a city the app does not know is kept as it is', () async {
      final (container, server) = await form(aram.copyWith(city: 'Paris'));
      final controller = container.read(editProfileProvider.notifier)
        ..setName('Ara');

      await controller.save();

      expect(server.profile.city, 'Paris');
    });
  });

  /// The Edit profile screen opened over a page, as it is over the profile.
  /// Answers with the server and the phone's picker.
  Future<(FakeProfileRepository, _FakePicker)> pumpScreen(
    WidgetTester tester, {
    required Profile profile,
  }) async {
    final server = FakeProfileRepository(profile);
    final picker = _FakePicker();
    ImagePickerPlatform.instance = picker;
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Consumer(
            builder: (_, ref, _) => Scaffold(
              body: Text(
                'profile of ${ref.watch(profileProvider).value?.fullName}',
              ),
            ),
          ),
        ),
        GoRoute(path: '/edit', builder: (_, _) => const EditProfileScreen()),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authStatusProvider.overrideWithValue(AuthStatus.signedIn),
          profileRepositoryProvider.overrideWithValue(server),
          citiesControllerProvider.overrideWith(_Cities.new),
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
    router.push('/edit');
    await tester.pumpAndSettle();
    return (server, picker);
  }

  DSButton saveButton(WidgetTester tester) =>
      tester.widget<DSButton>(find.widgetWithText(DSButton, 'Save'));

  /// Opens the list that shows [shown] and takes [option] from it.
  Future<void> choose(WidgetTester tester, String shown, String option) async {
    await tester.tap(find.text(shown));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  group('the Edit profile screen', () {
    testWidgets('shows what the profile holds', (tester) async {
      await pumpScreen(tester, profile: aram);

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Aram'), findsOneWidget);
      expect(find.text('Shahinyan'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('March'), findsOneWidget);
      expect(find.text('1995'), findsOneWidget);
      expect(find.text('Yerevan'), findsOneWidget);
      // Nothing is changed yet.
      expect(saveButton(tester).onPressed, isNull);
    });

    testWidgets('an empty profile shows what to choose', (tester) async {
      await pumpScreen(
        tester,
        profile: const Profile(name: '', surname: '', email: 'a@b.c'),
      );

      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
    });

    testWidgets('saves the changes and goes back to the profile', (
      tester,
    ) async {
      final (server, _) = await pumpScreen(tester, profile: aram);

      await tester.enterText(find.widgetWithText(TextField, 'Aram'), 'Aramik');
      await choose(tester, '12', '5');
      await choose(tester, 'Yerevan', 'Gyumri');
      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(server.profile.name, 'Aramik');
      expect(server.profile.birthday, DateTime(1995, 3, 5));
      expect(server.profile.city, 'c-gyumri');
      expect(server.profile.gender, Gender.female);
      expect(find.byType(EditProfileScreen), findsNothing);
      expect(find.text('profile of Aramik Shahinyan'), findsOneWidget);
    });

    testWidgets('a birthday chosen in part cannot be saved', (tester) async {
      await pumpScreen(
        tester,
        profile: const Profile(name: 'Aram', surname: '', email: 'a@b.c'),
      );

      await choose(tester, 'Month', 'March');
      expect(saveButton(tester).onPressed, isNull);

      await choose(tester, 'Day', '5');
      await choose(tester, 'Year', '${DateTime.now().year - 1}');
      expect(saveButton(tester).onPressed, isNotNull);
    });

    testWidgets('a refused save stays on the screen and says why', (
      tester,
    ) async {
      final (server, _) = await pumpScreen(tester, profile: aram);
      server.changeError = const AppException(
        AppExceptionKind.server,
        message: 'Not now',
      );

      await tester.enterText(find.widgetWithText(TextField, 'Aram'), 'Ara');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
      expect(find.text('Ara'), findsOneWidget);
    });

    testWidgets('a photo taken from the gallery is saved at once', (
      tester,
    ) async {
      final (server, picker) = await pumpScreen(tester, profile: aram);
      picker.picked = XFile('picked.jpg');

      await tester.tap(find.text('Change photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();

      expect(picker.asked, ImageSource.gallery);
      expect(server.photos, ['picked.jpg']);
      // The form under it is as it was.
      expect(find.byType(EditProfileScreen), findsOneWidget);
      expect(server.updates, 0);
    });

    testWidgets('the camera is the other place to take a photo from', (
      tester,
    ) async {
      final (server, picker) = await pumpScreen(tester, profile: aram);
      picker.picked = XFile('shot.jpg');

      await tester.tap(find.text('Change photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take a photo'));
      await tester.pumpAndSettle();

      expect(picker.asked, ImageSource.camera);
      expect(server.photos, ['shot.jpg']);
    });

    testWidgets('choosing no photo changes nothing', (tester) async {
      final (server, _) = await pumpScreen(tester, profile: aram);

      await tester.tap(find.text('Change photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();

      expect(server.photos, isEmpty);
    });

    testWidgets('a refused photo is said and the form stays', (tester) async {
      final (server, picker) = await pumpScreen(tester, profile: aram);
      picker.picked = XFile('picked.jpg');
      server.changeError = const AppException(
        AppExceptionKind.server,
        message: 'Too large',
      );

      await tester.tap(find.text('Change photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();

      expect(find.text('Too large'), findsOneWidget);
      expect(find.byType(EditProfileScreen), findsOneWidget);
    });
  });
}
