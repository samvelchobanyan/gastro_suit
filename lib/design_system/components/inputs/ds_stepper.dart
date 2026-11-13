import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// Stepper sizes: `sm` is 32 high, `md` 40.
enum DSStepperSize { sm, md }

/// A quantity with a minus and a plus (handoff `Stepper`).
///
/// Keeps no number of its own: it shows [value] and reports the number the
/// user asked for; whoever owns the quantity passes the new one back.
class DSStepper extends StatelessWidget {
  const DSStepper({
    super.key,
    required this.value,
    required this.onChanged,
    required this.decreaseLabel,
    required this.increaseLabel,
    this.size = DSStepperSize.sm,
    this.min = 0,
    this.max = 99,
  });

  final int value;

  /// Called with [value] minus or plus one, kept within [min] and [max].
  final ValueChanged<int> onChanged;

  /// What the buttons do, for screen readers.
  final String decreaseLabel;
  final String increaseLabel;

  final DSStepperSize size;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (button, valueWidth, textStyle, iconSize) = switch (size) {
      DSStepperSize.sm => (
        DSSizes.buttonHeightXxs,
        DSSizes.buttonHeightXxs,
        DSTypography.bodySmSemibold,
        DSSizes.iconSm,
      ),
      DSStepperSize.md => (
        DSSizes.buttonHeightSm,
        DSSizes.stepperValueWidthMd,
        DSTypography.bodySemibold,
        DSSizes.iconMd,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgCanvas,
        borderRadius: BorderRadius.circular(DSRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: PhosphorIcons.minus(),
            label: decreaseLabel,
            dimension: button,
            iconSize: iconSize,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: valueWidth),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                color: colors.textPrimary,
                // Digits of one width: the buttons do not shift as it counts.
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          _StepButton(
            icon: PhosphorIcons.plus(),
            label: increaseLabel,
            dimension: button,
            iconSize: iconSize,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.dimension,
    required this.iconSize,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final double dimension;
  final double iconSize;

  /// Null at the limit: the button is shown disabled.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: dimension,
          child: Icon(
            icon,
            size: iconSize,
            color: onTap != null ? colors.textPrimary : colors.textDisabled,
          ),
        ),
      ),
    );
  }
}
