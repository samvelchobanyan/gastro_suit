import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/overlays/ds_bottom_sheet.dart';
import 'package:gastro_suit/design_system/foundations/ds_spacing.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  const screenHeight = 640.0;
  const content = Key('content');

  Future<void> openSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, screenHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDSBottomSheet<void>(
                context: context,
                title: 'Title',
                child: const SizedBox(key: content, height: 100),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the content ends a margin above the bottom of the screen', (
    tester,
  ) async {
    await openSheet(tester);

    expect(
      tester.getRect(find.byKey(content)).bottom,
      screenHeight - DSSpacing.lg,
    );
  });

  testWidgets('the content stays above the keyboard', (tester) async {
    await openSheet(tester);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byKey(content)).bottom,
      screenHeight - 300 - DSSpacing.lg,
    );
    // The surface runs down under the keyboard: no gap shows the scrim.
    expect(tester.getRect(find.byType(DSBottomSheet)).bottom, screenHeight);
  });
}
