import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_text_area.dart';
import 'package:gastro_suit/design_system/foundations/ds_opacity.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  late TextEditingController controller;

  setUp(() => controller = TextEditingController());
  tearDown(() => controller.dispose());

  Future<void> pumpArea(
    WidgetTester tester, {
    int? maxLength,
    bool enabled = true,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(lightColors),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: DSTextArea(
            controller: controller,
            hintText: 'Tell us about your visit',
            maxLength: maxLength,
            enabled: enabled,
          ),
        ),
      ),
    ),
  );

  testWidgets('shows the hint while empty and puts the typed text into the '
      'controller', (tester) async {
    await pumpArea(tester);
    expect(find.text('Tell us about your visit'), findsOneWidget);

    await tester.enterText(find.byType(DSTextArea), 'Great coffee');

    expect(controller.text, 'Great coffee');
  });

  testWidgets('typing stops at the longest allowed text', (tester) async {
    await pumpArea(tester, maxLength: 5);

    await tester.enterText(find.byType(DSTextArea), 'Great coffee');

    expect(controller.text, 'Great');
  });

  testWidgets('keeps its height when the text is longer than four lines', (
    tester,
  ) async {
    await pumpArea(tester);
    final empty = tester.getSize(find.byType(DSTextArea));

    await tester.enterText(find.byType(DSTextArea), 'line\n' * 10);
    await tester.pump();

    expect(tester.getSize(find.byType(DSTextArea)), empty);
  });

  testWidgets('disabled it is dimmed and cannot be edited', (tester) async {
    await pumpArea(tester, enabled: false);

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Opacity && widget.opacity == DSOpacity.disabled,
      ),
      findsOneWidget,
    );
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });
}
