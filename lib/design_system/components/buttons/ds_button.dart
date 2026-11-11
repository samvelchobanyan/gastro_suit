import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// Button sizes; the handoff's others (`lg`, `md`, `xs`) are added when used.
enum DSButtonSize { sm }

/// A filled brand button (handoff `Button`, variant `primary`). The other
/// variants are added when a screen needs them.
class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.size,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final DSButtonSize size;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (height, padding, textStyle) = switch (size) {
      DSButtonSize.sm => (
        DSSizes.buttonHeightSm,
        DSSpacing.base,
        DSTypography.bodySemibold,
      ),
    };

    final button = FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? colors.brandInteractive
              : colors.brandPrimary,
        ),
        foregroundColor: WidgetStatePropertyAll(colors.textOnBrand),
        // The pressed colour is the feedback; no ripple on top of it.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        minimumSize: WidgetStatePropertyAll(Size(0, height)),
        fixedSize: WidgetStatePropertyAll(Size.fromHeight(height)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: padding),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(DSRadius.md)),
          ),
        ),
        textStyle: WidgetStatePropertyAll(textStyle),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
