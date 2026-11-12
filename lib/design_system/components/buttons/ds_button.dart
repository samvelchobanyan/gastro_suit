import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// Button sizes; the handoff's others (`lg`, `md`, `xs`) are added when used.
enum DSButtonSize { sm }

/// How a button is painted. The handoff's `tertiary` and `destructive` are
/// added when a screen needs them.
enum DSButtonVariant {
  /// The brand fill: the main action.
  primary,

  /// An outline: an action that is not the main one, or not ready yet.
  secondary,
}

/// A button with a label and an optional icon before it (handoff `Button`).
class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.size,
    this.variant = DSButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final DSButtonSize size;
  final DSButtonVariant variant;

  /// Shown before the label.
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = this.icon;
    final (height, padding, textStyle) = switch (size) {
      DSButtonSize.sm => (
        DSSizes.buttonHeightSm,
        DSSpacing.base,
        DSTypography.bodySemibold,
      ),
    };
    final (
      background,
      pressedBackground,
      foreground,
      border,
    ) = switch (variant) {
      DSButtonVariant.primary => (
        colors.brandPrimary,
        colors.brandInteractive,
        colors.textOnBrand,
        BorderSide.none,
      ),
      DSButtonVariant.secondary => (
        Colors.transparent,
        colors.brandSubtle,
        colors.textPrimary,
        BorderSide(
          color: colors.borderDefault,
          width: DSSizes.borderWidthDefault,
        ),
      ),
    };

    final button = FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? pressedBackground
              : background,
        ),
        foregroundColor: WidgetStatePropertyAll(foreground),
        // The pressed colour is the feedback; no ripple on top of it.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        minimumSize: WidgetStatePropertyAll(Size(0, height)),
        fixedSize: WidgetStatePropertyAll(Size.fromHeight(height)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: padding),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(DSRadius.md)),
            side: border,
          ),
        ),
        textStyle: WidgetStatePropertyAll(textStyle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: DSSizes.iconSm),
            const SizedBox(width: DSSpacing.sm),
          ],
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
