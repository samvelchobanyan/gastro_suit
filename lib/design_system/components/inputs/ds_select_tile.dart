import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One of a few choices shown side by side as bordered tiles, the chosen one
/// tinted with the brand (the frame of the handoff's `SizeSelector` and
/// `LanguageSwitcher`).
///
/// Only the frame: the caller builds what is inside and colours it for
/// [selected] (`textAccent` when selected).
class DSSelectTile extends StatelessWidget {
  const DSSelectTile({
    super.key,
    required this.selected,
    required this.onTap,
    required this.padding,
    required this.child,
  });

  final bool selected;

  /// Null when the choice cannot be made: the tile is dimmed and takes no
  /// taps.
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: onTap != null ? 1 : DSOpacity.disabled,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: selected ? colors.brandSubtle : colors.bgMain,
              borderRadius: BorderRadius.circular(DSRadius.md),
              border: Border.all(
                color: selected ? colors.brandPrimary : colors.borderDefault,
                width: DSSizes.borderWidthDefault,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
