import 'dart:ui';

import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One item of [DSBottomNavigation]: an outline icon, the filled icon shown
/// while it is active, and a label. The label is not drawn; it is what a
/// screen reader says.
class DSBottomNavigationItem {
  const DSBottomNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// The app's bottom navigation (handoff `NavFloatingIcons`, drawn as glass
/// by the pages): a pill of icons floating over the screen's content. A
/// plate under the active icon slides to the one chosen next.
///
/// Its height includes the margin under it and the system's bottom inset:
/// in `Scaffold.bottomNavigationBar` with `extendBody` the content goes
/// under it and gets that height as its bottom padding.
///
/// [currentIndex] is the active item, or null when none of the items is
/// where the user is. An item that only opens something over the screen is
/// never the active one: that is the caller's to keep.
class DSBottomNavigation extends StatefulWidget {
  const DSBottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<DSBottomNavigationItem> items;
  final int? currentIndex;
  final ValueChanged<int> onSelected;

  @override
  State<DSBottomNavigation> createState() => _DSBottomNavigationState();
}

class _DSBottomNavigationState extends State<DSBottomNavigation>
    with SingleTickerProviderStateMixin {
  // The handoff's squash of the plate and pop of the icon on a change.
  static final _plateWidth = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.12), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 0.97), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 0.97, end: 1), weight: 30),
  ]);
  static final _plateHeight = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.03), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.03, end: 1), weight: 30),
  ]);
  static final _iconPop = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 0.82), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.12), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1), weight: 35),
  ]);

  late final AnimationController _change;
  late final Animation<double> _eased;

  @override
  void initState() {
    super.initState();
    _change = AnimationController(
      vsync: this,
      duration: DSMotion.slower,
      value: 1,
    );
    _eased = CurvedAnimation(parent: _change, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(DSBottomNavigation old) {
    super.didUpdateWidget(old);
    if (widget.currentIndex == old.currentIndex) return;
    // A list that changed its length moved the active item, not the user.
    final moved = widget.items.length == old.items.length;
    if (moved && !MediaQuery.disableAnimationsOf(context)) {
      _change.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _change.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(DSRadius.full);
    final current = widget.currentIndex;
    final still = MediaQuery.disableAnimationsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        DSSpacing.base,
        0,
        DSSpacing.base,
        DSSpacing.base + MediaQuery.paddingOf(context).bottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: DSElevation.sm,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: DSSizes.glassBlur,
              sigmaY: DSSizes.glassBlur,
            ),
            child: Container(
              height: DSSizes.bottomNavHeight,
              decoration: BoxDecoration(
                color: colors.glassBg,
                borderRadius: radius,
                border: Border.all(
                  color: colors.glassBorder,
                  width: DSSizes.borderWidthDefault,
                ),
              ),
              padding: const EdgeInsets.all(DSSpacing.xs),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / widget.items.length;
                  return Stack(
                    children: [
                      if (current != null)
                        AnimatedPositionedDirectional(
                          duration: still ? Duration.zero : DSMotion.slower,
                          curve: DSMotion.emphasized,
                          start: itemWidth * current,
                          top: 0,
                          bottom: 0,
                          width: itemWidth,
                          child: AnimatedBuilder(
                            animation: _eased,
                            builder: (context, child) => Transform.scale(
                              scaleX: _plateWidth.evaluate(_eased),
                              scaleY: _plateHeight.evaluate(_eased),
                              child: child,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.bgCanvas,
                                borderRadius: radius,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          for (var i = 0; i < widget.items.length; i++)
                            Expanded(
                              child: _Item(
                                item: widget.items[i],
                                active: i == current,
                                pop: i == current
                                    ? _iconPop.animate(_eased)
                                    : null,
                                onTap: () => widget.onSelected(i),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    required this.active,
    required this.pop,
    required this.onTap,
  });

  final DSBottomNavigationItem item;
  final bool active;

  /// The scale of the icon while it pops; null for an icon that does not.
  final Animation<double>? pop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget icon = Icon(
      active ? item.activeIcon : item.icon,
      size: DSSizes.iconMd,
      color: active ? colors.brandPrimary : colors.textPrimary,
    );
    if (pop case final pop?) icon = ScaleTransition(scale: pop, child: icon);

    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(child: icon),
      ),
    );
  }
}
