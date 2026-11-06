import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/ds_extensions.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  testWidgets('context.colors returns the role set the theme was built with', (
    tester,
  ) async {
    late DSColors colors;
    late ThemeData theme;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        home: Builder(
          builder: (context) {
            colors = context.colors;
            theme = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(colors, same(lightColors));
    // Stock widgets are coloured from the same set.
    expect(theme.colorScheme.primary, lightColors.brandPrimary);
    expect(theme.textTheme.bodyMedium!.color, lightColors.textPrimary);
  });

  test('line heights match the handoff in pixels', () {
    expect(DSTypography.body.fontSize! * DSTypography.body.height!, 20);
    expect(DSTypography.h1.fontSize! * DSTypography.h1.height!, 32);
    expect(DSTypography.overline.fontSize! * DSTypography.overline.height!, 12);
  });
}
