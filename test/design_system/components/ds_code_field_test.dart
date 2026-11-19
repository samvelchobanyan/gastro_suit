import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_code_field.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  late TextEditingController controller;

  setUp(() => controller = TextEditingController());
  tearDown(() => controller.dispose());

  Future<List<String>> pumpField(
    WidgetTester tester, {
    double width = 360,
    bool error = false,
  }) async {
    tester.view.physicalSize = Size(width, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final completed = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: DSCodeField(
              controller: controller,
              length: 6,
              semanticLabel: 'Code',
              error: error,
              onCompleted: completed.add,
            ),
          ),
        ),
      ),
    );
    return completed;
  }

  /// The border colours of the cells, in order.
  List<Color> borders(WidgetTester tester) => [
    for (final box in tester.widgetList<Container>(
      find.descendant(
        of: find.byType(DSCodeField),
        matching: find.byType(Container),
      ),
    ))
      ((box.decoration! as BoxDecoration).border! as Border).top.color,
  ];

  testWidgets('each digit goes to its cell; the whole code is reported', (
    tester,
  ) async {
    final completed = await pumpField(tester);

    await tester.enterText(find.byType(TextField), '12a3');
    await tester.pump();
    expect(controller.text, '123');
    expect(find.text('1'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(completed, isEmpty);

    // A pasted code that is too long is cut to the cells there are.
    await tester.enterText(find.byType(TextField), '1234567');
    await tester.pump();
    expect(controller.text, '123456');
    expect(completed, ['123456']);
  });

  testWidgets('the cell the next digit goes to is outlined while typing', (
    tester,
  ) async {
    await pumpField(tester);
    expect(borders(tester).toSet(), {lightColors.borderDefault});

    await tester.tap(find.byType(DSCodeField));
    await tester.enterText(find.byType(TextField), '12');
    await tester.pump();

    final colors = borders(tester);
    expect(colors[2], lightColors.borderInteractive);
    expect(colors.where((c) => c == lightColors.borderInteractive).length, 1);
  });

  testWidgets('a wrong code outlines every cell', (tester) async {
    await pumpField(tester, error: true);

    expect(borders(tester).toSet(), {lightColors.statusError});
  });

  testWidgets('six cells are 48 wide on a 360 screen and shrink on a '
      'narrower one', (tester) async {
    await pumpField(tester);
    final cell = find
        .descendant(
          of: find.byType(DSCodeField),
          matching: find.byType(Container),
        )
        .first;
    expect(tester.getSize(cell), const Size(48, 48));

    await pumpField(tester, width: 320);
    expect(tester.getSize(cell).width, lessThan(48));
    expect(tester.takeException(), isNull);
  });
}
