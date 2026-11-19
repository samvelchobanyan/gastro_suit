import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// One row of a list (handoff `AdvancedListItem`): an icon in a recessed
/// square, a title with an optional line under it, then a control and / or
/// an arrow.
class DSListItem extends StatefulWidget {
  const DSListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.chevron = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// A control at the end of the row (a toggle).
  final Widget? trailing;

  /// An arrow at the end: the row leads somewhere.
  final bool chevron;

  /// Null for a row that only shows, or whose control takes the taps.
  final VoidCallback? onTap;

  @override
  State<DSListItem> createState() => _DSListItemState();
}

class _DSListItemState extends State<DSListItem> {
  var _pressed = false;

  void _setPressed(bool pressed) => setState(() => _pressed = pressed);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = widget.subtitle;
    final trailing = widget.trailing;
    final onTap = widget.onTap;

    final row = Container(
      constraints: BoxConstraints(
        minHeight: subtitle != null
            ? DSSizes.listItemHeightTwoLine
            : DSSizes.listItemHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.base,
        vertical: DSSpacing.md,
      ),
      color: _pressed ? colors.overlayHoverDark : null,
      child: Row(
        children: [
          Container(
            width: DSSizes.listItemIcon,
            height: DSSizes.listItemIcon,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.bgSurfaceSunken,
              borderRadius: BorderRadius.circular(DSRadius.md),
            ),
            child: Icon(
              widget.icon,
              size: DSSizes.iconSm,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySemibold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySm.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: DSSpacing.md),
            trailing,
          ],
          if (widget.chevron) ...[
            const SizedBox(width: DSSpacing.md),
            Icon(
              PhosphorIcons.caretRight(),
              size: DSSizes.iconSm,
              color: colors.textTertiary,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: row,
      ),
    );
  }
}

/// Rows of a list in one bordered card, a line between each two (the card
/// around the handoff's `AdvancedListItem`s). The line starts where the
/// rows' text does.
class DSListGroup extends StatelessWidget {
  const DSListGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.bgMain,
        borderRadius: BorderRadius.circular(DSRadius.md),
        border: Border.all(
          color: colors.borderMuted,
          width: DSSizes.borderWidthDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0)
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: DSSpacing.base + DSSizes.listItemIcon,
                ),
                height: DSSizes.borderWidthDefault,
                color: colors.borderMuted,
              ),
            child,
          ],
        ],
      ),
    );
  }
}
