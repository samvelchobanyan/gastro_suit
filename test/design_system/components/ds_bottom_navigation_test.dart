import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/design_system/components/navigation/ds_bottom_navigation.dart';
import 'package:gastro_suit/design_system/theme/app_theme.dart';
import 'package:gastro_suit/design_system/theme/ds_colors.dart';

void main() {
  const items = [
    DSBottomNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    DSBottomNavigationItem(
      icon: Icons.coffee_outlined,
      activeIcon: Icons.coffee,
      label: 'Order',
    ),
    DSBottomNavigationItem(
      icon: Icons.qr_code,
      activeIcon: Icons.qr_code_2,
      label: 'Card',
    ),
    DSBottomNavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  Future<List<int>> pumpNav(
    WidgetTester tester, {
    int? current = 0,
    bool still = false,
    double systemInset = 0,
  }) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final selected = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(lightColors),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: still,
              padding: EdgeInsets.only(bottom: systemInset),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DSBottomNavigation(
                items: items,
                currentIndex: current,
                onSelected: selected.add,
              ),
            ),
          ),
        ),
      ),
    );
    return selected;
  }

  /// Where the plate under the active icon starts, from the pill's edge.
  double? plateStart(WidgetTester tester) => tester
      .widgetList<AnimatedPositionedDirectional>(
        find.byType(AnimatedPositionedDirectional),
      )
      .firstOrNull
      ?.start;

  testWidgets('shows icons only: the active one filled, in the brand colour', (
    tester,
  ) async {
    await pumpNav(tester, current: 1);

    expect(find.text('Order'), findsNothing);
    expect(find.bySemanticsLabel('Order'), findsOneWidget);
    final active = tester.widget<Icon>(find.byIcon(Icons.coffee));
    expect(active.color, lightColors.brandPrimary);
    final other = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
    expect(other.color, lightColors.textPrimary);
  });

  testWidgets('a tap says which item, and changes nothing by itself', (
    tester,
  ) async {
    final selected = await pumpNav(tester);

    await tester.tap(find.bySemanticsLabel('Card'));
    await tester.pump();

    expect(selected, [2]);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(plateStart(tester), 0);
  });

  testWidgets('the plate goes to the item that became active', (tester) async {
    await pumpNav(tester);
    // 360 wide; 16 on each side, the border of 1 and 4 inside each edge:
    // four items of 79.5.
    expect(plateStart(tester), 0);

    await pumpNav(tester, current: 3);
    expect(plateStart(tester), 238.5);
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nothing moves when the system asks for no animations', (
    tester,
  ) async {
    await pumpNav(tester, still: true);

    await pumpNav(tester, current: 3, still: true);
    await tester.pump();

    expect(plateStart(tester), 238.5);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('no item active: no plate, every icon an outline', (
    tester,
  ) async {
    await pumpNav(tester, current: null);

    expect(plateStart(tester), isNull);
    expect(find.byIcon(Icons.home), findsNothing);
  });

  testWidgets('its height is the pill, the margin under it and the '
      'system inset', (tester) async {
    await pumpNav(tester);
    expect(tester.getSize(find.byType(DSBottomNavigation)).height, 48 + 16);

    await pumpNav(tester, systemInset: 34);
    expect(
      tester.getSize(find.byType(DSBottomNavigation)).height,
      48 + 16 + 34,
    );
  });
}
