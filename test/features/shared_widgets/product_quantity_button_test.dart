import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/buttons/ds_icon_button.dart';
import 'package:gastro_suit/design_system/components/inputs/ds_stepper.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';
import 'package:gastro_suit/features/shared_widgets/product_quantity_button.dart';
import 'package:gastro_suit/l10n/generated/app_localizations.dart';

void main() {
  /// Pumps the button and returns the quantities it asks for.
  Future<List<int>> pumpButton(
    WidgetTester tester, {
    required int quantity,
  }) async {
    final asked = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: ProductQuantityButton(
              quantity: quantity,
              onChanged: asked.add,
              addButtonSize: DSIconButtonSize.sm,
            ),
          ),
        ),
      ),
    );
    return asked;
  }

  testWidgets('with none in the cart it is a plus that asks for one', (
    tester,
  ) async {
    final asked = await pumpButton(tester, quantity: 0);
    expect(find.byType(DSStepper), findsNothing);

    await tester.tap(find.bySemanticsLabel('Add to cart'));
    expect(asked, [1]);
  });

  testWidgets('with some in the cart it is a stepper around the quantity', (
    tester,
  ) async {
    final asked = await pumpButton(tester, quantity: 2);
    expect(find.byType(DSIconButton), findsNothing);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Increase quantity'));
    await tester.tap(find.bySemanticsLabel('Decrease quantity'));
    expect(asked, [3, 1]);
    // It keeps no number of its own: the cart passes the new one back.
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('the last one can be taken out', (tester) async {
    final asked = await pumpButton(tester, quantity: 1);
    await tester.tap(find.bySemanticsLabel('Decrease quantity'));
    expect(asked, [0]);
  });
}
