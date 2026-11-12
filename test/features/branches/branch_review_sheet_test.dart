import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_rating_input.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/branch_review.dart';
import 'package:gastro_suit/domain/entities/city.dart';
import 'package:gastro_suit/domain/repositories/branch_repository.dart';
import 'package:gastro_suit/domain/state/branches_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';
import 'package:gastro_suit/features/branches/branch_review_sheet/branch_review_sheet.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

class _FakeRepository implements BranchRepository {
  /// What the user gave earlier.
  BranchReview? review;
  Object? loadError;
  Object? sendError;

  /// The branch as the server has it after a rating; an error when it
  /// cannot be loaded.
  Branch? branch;

  /// Every rating sent: branch, stars, words.
  final sent = <(String, int, String)>[];

  @override
  Future<BranchReview?> getReview(String branchId) async {
    if (loadError case final error?) throw error;
    return review;
  }

  @override
  Future<BranchReview> rateBranch(
    String branchId, {
    required int rating,
    required String text,
  }) async {
    sent.add((branchId, rating, text));
    if (sendError case final error?) throw error;
    return BranchReview(rating: rating, text: text.isEmpty ? null : text);
  }

  @override
  Future<Branch> getBranch(
    String branchId, {
    required ContentLanguage language,
  }) async => branch ?? (throw const AppException(AppExceptionKind.server));

  @override
  Future<List<Branch>> getBranches({
    required String restaurantId,
    required ContentLanguage language,
  }) async => const [];

  @override
  Future<List<City>> getCities({
    required String restaurantId,
    required ContentLanguage language,
  }) async => const [];
}

const _other = Branch(
  id: 'b0',
  name: 'Kentron',
  address: 'Abovyan 5',
  rating: BranchRating(average: 4.6, count: 218),
  isTemporarilyClosed: false,
);

const _rated = Branch(
  id: 'b1',
  name: 'Cascade',
  address: 'Tamanyan 1',
  rating: BranchRating(average: 4.2, count: 57),
  isTemporarilyClosed: false,
);

/// The loaded list: two branches with their distances. Counts its loads.
class _FakeBranches extends BranchesController {
  _FakeBranches(this.onLoad);

  final VoidCallback onLoad;

  @override
  Future<List<NearbyBranch>> build() async {
    onLoad();
    return const [NearbyBranch(_other, 0.4), NearbyBranch(_rated, 1.2)];
  }
}

void main() {
  late _FakeRepository repository;
  late int branchLoads;

  setUp(() {
    repository = _FakeRepository();
    branchLoads = 0;
  });

  Future<void> openSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        // As in the app: a failed load is not repeated on its own.
        retry: (_, _) => null,
        overrides: [
          branchRepositoryProvider.overrideWithValue(repository),
          branchesControllerProvider.overrideWith(
            () => _FakeBranches(() => branchLoads++),
          ),
          contentLanguageProvider.overrideWith(
            (ref) => const ContentLanguage(current: 'en', fallback: null),
          ),
        ],
        child: MaterialApp(
          theme: buildAppTheme(lightColors),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                // Someone shows the branches, as the branch screen does:
                // each one's rating and distance, in the list's order.
                final branches =
                    ref.watch(branchesControllerProvider).value ?? const [];
                return Column(
                  children: [
                    for (final item in branches)
                      Text(
                        '${item.branch.name} ${item.branch.rating?.average} '
                        '(${item.branch.rating?.count}) ${item.distanceKm}',
                      ),
                    TextButton(
                      onPressed: () => showBranchReview(context, 'b1'),
                      child: const Text('Open'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  int rating(WidgetTester tester) =>
      tester.widget<DSRatingInput>(find.byType(DSRatingInput)).value;

  testWidgets('opens empty for a user who has not rated the branch, and '
      'sends nothing without a star', (tester) async {
    await openSheet(tester);

    expect(find.text('Leave a feedback'), findsOneWidget);
    expect(rating(tester), 0);
    expect(find.text('Tell us about your visit'), findsOneWidget);

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(repository.sent, isEmpty);
    expect(find.text('Leave a feedback'), findsOneWidget);
  });

  testWidgets('opens on the rating the user gave earlier', (tester) async {
    repository.review = const BranchReview(rating: 4, text: 'Great coffee');
    await openSheet(tester);

    expect(rating(tester), 4);
    expect(find.text('Great coffee'), findsOneWidget);
  });

  testWidgets('sends the stars and the words, closes, and loads that one '
      'branch again', (tester) async {
    repository.branch = _rated.copyWith(
      rating: const BranchRating(average: 4.3, count: 58),
    );
    await openSheet(tester);
    expect(find.text('Cascade 4.2 (57) 1.2'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('5 of 5'));
    await tester.enterText(find.byType(TextField), ' Nice place ');
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(repository.sent, [('b1', 5, 'Nice place')]);
    expect(find.text('Leave a feedback'), findsNothing);
    // The new rating, the same distance, the same place in the list.
    expect(find.text('Cascade 4.3 (58) 1.2'), findsOneWidget);
    expect(find.text('Kentron 4.6 (218) 0.4'), findsOneWidget);
    expect(
      tester.getTopLeft(find.textContaining('Kentron')).dy,
      lessThan(tester.getTopLeft(find.textContaining('Cascade')).dy),
    );
    // The list itself was not loaded again.
    expect(branchLoads, 1);
  });

  testWidgets('an accepted rating closes the sheet even when the branch '
      'cannot be loaded again; the list stays as it was', (tester) async {
    await openSheet(tester);

    await tester.tap(find.bySemanticsLabel('5 of 5'));
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Leave a feedback'), findsNothing);
    expect(find.text('Cascade 4.2 (57) 1.2'), findsOneWidget);
  });

  testWidgets('a rating that was not accepted keeps the sheet open with '
      'what was entered and says why', (tester) async {
    repository.sendError = const AppException(
      AppExceptionKind.server,
      code: 'validation_failed',
      message: 'The words are too long',
    );
    await openSheet(tester);

    await tester.tap(find.bySemanticsLabel('3 of 5'));
    await tester.enterText(find.byType(TextField), 'So-so');
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('The words are too long'), findsOneWidget);
    expect(rating(tester), 3);
    expect(find.text('So-so'), findsOneWidget);
    expect(find.text('Cascade 4.2 (57) 1.2'), findsOneWidget);

    // The second try goes through.
    repository.sendError = null;
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Leave a feedback'), findsNothing);
  });

  testWidgets('a failed load shows the error and loads again on retry', (
    tester,
  ) async {
    repository.loadError = const AppException(AppExceptionKind.noConnection);
    await openSheet(tester);

    expect(find.byType(DSRatingInput), findsNothing);
    expect(find.text('Try again'), findsOneWidget);

    repository
      ..loadError = null
      ..review = const BranchReview(rating: 2);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(rating(tester), 2);
  });
}
