import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// How an icon button is painted. The handoff's `ghost` is added when used.
enum DSIconButtonVariant {
  /// The brand fill: the main action of its place (add to cart).
  filled,

  /// A brand-tinted fill: a secondary action (back, map).
  tonal,
}

/// Compact sizes; the handoff's others are added when used. Both are below
/// the 48 touch minimum, so leave room around them.
enum DSIconButtonSize { xs, sm }

/// The outline of an icon button.
enum DSIconButtonShape {
  circle,

  /// A square with the corners of an input (the handoff's `radius="input"`),
  /// for a button that stands next to a field.
  rounded,
}

/// A button with only an icon, round unless told otherwise (handoff
/// `IconButton`).
class DSIconButton extends StatefulWidget {
  const DSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    required this.variant,
    required this.size,
    this.shape = DSIconButtonShape.circle,
  });

  final IconData icon;
  final VoidCallback onPressed;

  /// What the button does, for screen readers.
  final String semanticLabel;
  final DSIconButtonVariant variant;
  final DSIconButtonSize size;
  final DSIconButtonShape shape;

  @override
  State<DSIconButton> createState() => _DSIconButtonState();
}

class _DSIconButtonState extends State<DSIconButton> {
  var _pressed = false;

  void _setPressed(bool pressed) => setState(() => _pressed = pressed);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (diameter, iconSize) = switch (widget.size) {
      DSIconButtonSize.xs => (DSSizes.buttonHeightXs, DSSizes.iconXs),
      DSIconButtonSize.sm => (DSSizes.buttonHeightSm, DSSizes.iconSm),
    };
    final (background, foreground) = switch (widget.variant) {
      DSIconButtonVariant.filled => (
        _pressed ? colors.brandInteractive : colors.brandPrimary,
        colors.textOnBrand,
      ),
      DSIconButtonVariant.tonal => (
        _pressed
            ? Color.alphaBlend(colors.overlayPressDark, colors.brandSubtle)
            : colors.brandSubtle,
        colors.textAccent,
      ),
    };

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: Container(
          width: diameter,
          height: diameter,
          alignment: Alignment.center,
          decoration: switch (widget.shape) {
            DSIconButtonShape.circle => BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            DSIconButtonShape.rounded => BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(DSRadius.input),
            ),
          },
          child: Icon(widget.icon, size: iconSize, color: foreground),
        ),
      ),
    );
  }
}
