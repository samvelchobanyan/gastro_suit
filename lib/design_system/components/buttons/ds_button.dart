import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// Button sizes: `sm` is 40 high, `md` 48. The handoff's others (`lg`,
/// `xs`) are added when used.
enum DSButtonSize { sm, md }

/// How a button is painted. The handoff's `tertiary` and `destructive` are
/// added when a screen needs them.
enum DSButtonVariant {
  /// The brand fill: the main action.
  primary,

  /// An outline: an action that is not the main one, or not ready yet.
  secondary,
}

/// A button with a label and an optional icon before it (handoff `Button`).
///
/// Without [onPressed] it is disabled: dimmed, and takes no taps. While
/// [loading] it shows a spinner in place of the label and takes no taps
/// either.
class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.size,
    this.variant = DSButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  final String label;

  /// Null when the action is not available now.
  final VoidCallback? onPressed;
  final DSButtonSize size;
  final DSButtonVariant variant;

  /// Shown before the label.
  final IconData? icon;
  final bool fullWidth;

  /// The action is under way.
  final bool loading;

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
      DSButtonSize.md => (
        DSSizes.buttonHeightMd,
        DSSpacing.base,
        DSTypography.bodyLgSemibold,
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
      onPressed: loading ? null : onPressed,
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
      child: loading
          ? Semantics(
              label: label,
              child: SizedBox.square(
                dimension: DSSizes.iconSm - DSSpacing.xxs,
                child: CircularProgressIndicator(
                  strokeWidth: DSSizes.borderWidthThick,
                  color: foreground,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: DSSizes.iconSm),
                  const SizedBox(width: DSSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );

    final sized = fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
    // A loading button is not dimmed: its action is running.
    return onPressed == null && !loading
        ? Opacity(opacity: DSOpacity.disabled, child: sized)
        : sized;
  }
}
