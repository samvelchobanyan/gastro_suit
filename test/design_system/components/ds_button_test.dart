import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_button.dart';
import 'package:gastro_suit/design_system/foundations/ds_opacity.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  Future<void> pumpButton(
    WidgetTester tester, {
    required VoidCallback? onPressed,
    bool loading = false,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(lightColors),
      home: Scaffold(
        body: Center(
          child: DSButton(
            label: 'Send',
            size: DSButtonSize.sm,
            onPressed: onPressed,
            loading: loading,
          ),
        ),
      ),
    ),
  );

  Finder dimmed() => find.byWidgetPredicate(
    (widget) => widget is Opacity && widget.opacity == DSOpacity.disabled,
  );

  testWidgets('takes taps and is not dimmed when it has an action', (
    tester,
  ) async {
    var taps = 0;
    await pumpButton(tester, onPressed: () => taps++);

    await tester.tap(find.text('Send'));

    expect(taps, 1);
    expect(dimmed(), findsNothing);
  });

  testWidgets('without an action it is dimmed and keeps its label', (
    tester,
  ) async {
    await pumpButton(tester, onPressed: null);

    expect(dimmed(), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('while loading it shows a spinner, takes no taps and is not '
      'dimmed', (tester) async {
    var taps = 0;
    await pumpButton(tester, onPressed: () => taps++, loading: true);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Send'), findsNothing);
    expect(dimmed(), findsNothing);

    await tester.tap(find.byType(DSButton));
    // The spinner never settles: one frame is enough.
    await tester.pump();

    expect(taps, 0);
  });
}
