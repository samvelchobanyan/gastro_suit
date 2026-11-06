import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/ds_extensions.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/brands/coffee_house_brand.dart';
import 'package:gastro_suit/design_system/theme/brands/demo_brand.dart';

void main() {
  for (final brand in [coffeeHouseBrand, demoBrand]) {
    testWidgets('context.brand returns the brand the theme was built with',
        (tester) async {
      late DSBrand read;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(brand),
          home: Builder(builder: (context) {
            read = context.brand;
            return const SizedBox();
          }),
        ),
      );
      expect(read, same(brand));
      expect(Theme.of(tester.element(find.byType(SizedBox))).colorScheme.primary,
          brand.brandPrimary);
    });
  }

  test('line heights match the handoff in pixels', () {
    expect(DSTypography.body.fontSize! * DSTypography.body.height!, 20);
    expect(DSTypography.h1.fontSize! * DSTypography.h1.height!, 32);
    expect(DSTypography.overline.fontSize! * DSTypography.overline.height!, 12);
  });
}
