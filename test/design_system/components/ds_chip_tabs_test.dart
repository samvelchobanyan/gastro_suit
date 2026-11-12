import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_chip_tabs.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  const screenWidth = 360.0;
  const margin = 16.0;

  // Eight chips: more than the screen is wide.
  final options = [
    for (var i = 1; i <= 8; i++) DSChipTab(value: i, label: 'Sub $i'),
  ];

  Future<void> pumpChips(WidgetTester tester, {required int value}) async {
    tester.view.physicalSize = const Size(screenWidth, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        home: Scaffold(
          // A page that scrolls too: only the row of chips may move.
          body: ListView(
            children: [
              const SizedBox(height: 300),
              DSChipTabs<int>(
                options: options,
                value: value,
                onChanged: (_) {},
                padding: const EdgeInsets.symmetric(horizontal: margin),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Rect chip(WidgetTester tester, int i) =>
      tester.getRect(find.text('Sub $i'));

  double rowOffset(WidgetTester tester) => tester
      .state<ScrollableState>(
        find.descendant(
          of: find.byType(DSChipTabs<int>),
          matching: find.byType(Scrollable),
        ),
      )
      .position
      .pixels;

  double pageOffset(WidgetTester tester) => tester
      .state<ScrollableState>(find.byType(Scrollable).first)
      .position
      .pixels;

  testWidgets('a chip in view does not move the row', (tester) async {
    await pumpChips(tester, value: 1);
    expect(rowOffset(tester), 0);

    await pumpChips(tester, value: 2);
    expect(rowOffset(tester), 0);
  });

  testWidgets('selecting a chip past the edge scrolls the row to show it', (
    tester,
  ) async {
    await pumpChips(tester, value: 1);
    expect(chip(tester, 6).left, greaterThan(screenWidth));

    await pumpChips(tester, value: 6);

    expect(rowOffset(tester), greaterThan(0));
    // Wholly in view, and no further than needed: it sits at the end.
    expect(chip(tester, 6).left, greaterThan(0));
    expect(chip(tester, 6).right, lessThanOrEqualTo(screenWidth - margin));
    expect(chip(tester, 7).right, greaterThan(screenWidth));
    // The page under the row stays where it was.
    expect(pageOffset(tester), 0);
  });

  testWidgets('and back to a chip before the edge', (tester) async {
    await pumpChips(tester, value: 8);
    expect(chip(tester, 1).right, lessThan(0));

    await pumpChips(tester, value: 2);

    expect(chip(tester, 2).left, greaterThanOrEqualTo(margin));
    expect(chip(tester, 2).right, lessThan(screenWidth));
    expect(chip(tester, 1).left, lessThan(0));
  });

  testWidgets('opens with the selected chip in view', (tester) async {
    await pumpChips(tester, value: 8);

    expect(rowOffset(tester), greaterThan(0));
    expect(chip(tester, 8).right, lessThanOrEqualTo(screenWidth - margin));
  });
}
