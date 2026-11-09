import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One destination of [DSBottomNavigation]: an outline icon, the filled icon
/// shown while it is active, and a label.
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

/// The app's bottom navigation bar (handoff `BottomNavigation`): a flat bar
/// with a hairline on top; the active item is marked only by the brand colour
/// and a filled icon.
///
/// Material's `NavigationBar` cannot be used: its fixed internal layout
/// (indicator, label spacing) does not fit the design's 48px height.
class DSBottomNavigation extends StatelessWidget {
  const DSBottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<DSBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(
          top: BorderSide(
            color: colors.borderMuted,
            width: DSSizes.borderWidthDefault,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.base,
            vertical: DSSpacing.sm,
          ),
          child: SizedBox(
            height: DSSizes.bottomNavHeight,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _Item(
                      item: items[i],
                      active: i == currentIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item, required this.active, required this.onTap});

  final DSBottomNavigationItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? context.colors.brandPrimary
        : context.colors.textTertiary;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active ? item.activeIcon : item.icon,
              size: DSSizes.iconMd,
              color: color,
            ),
            const SizedBox(height: DSSpacing.xxs),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DSTypography.bodyXs.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
