import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_rating_input.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  Future<void> pumpInput(
    WidgetTester tester, {
    required int value,
    ValueChanged<int>? onChanged,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(lightColors),
      home: Scaffold(
        body: Center(
          child: DSRatingInput(
            value: value,
            onChanged: onChanged ?? (_) {},
            starLabel: (star) => '$star of 5',
          ),
        ),
      ),
    ),
  );

  int stars(WidgetTester tester, IconData icon) =>
      tester.widgetList<Icon>(find.byIcon(icon)).length;

  testWidgets('shows the rating as filled stars and the rest empty', (
    tester,
  ) async {
    await pumpInput(tester, value: 3);

    expect(stars(tester, PhosphorIcons.star(PhosphorIconsStyle.fill)), 3);
    expect(stars(tester, PhosphorIcons.star()), 2);
  });

  testWidgets('no rating is five empty stars', (tester) async {
    await pumpInput(tester, value: 0);

    expect(stars(tester, PhosphorIcons.star(PhosphorIconsStyle.fill)), 0);
    expect(stars(tester, PhosphorIcons.star()), 5);
  });

  testWidgets('a tap on a star reports its number and keeps no rating', (
    tester,
  ) async {
    final reported = <int>[];
    await pumpInput(tester, value: 2, onChanged: reported.add);

    await tester.tap(find.bySemanticsLabel('4 of 5'));
    await tester.pump();

    expect(reported, [4]);
    // Still what it was given: the owner passes the new rating back.
    expect(stars(tester, PhosphorIcons.star(PhosphorIconsStyle.fill)), 2);
  });

  testWidgets('the chosen star is marked selected for screen readers', (
    tester,
  ) async {
    await pumpInput(tester, value: 4);

    expect(
      tester.getSemantics(find.bySemanticsLabel('4 of 5')),
      containsSemantics(isButton: true, isSelected: true, label: '4 of 5'),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('3 of 5')),
      containsSemantics(isButton: true, isSelected: false, label: '3 of 5'),
    );
  });
}
