import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// A quantity with a minus and a plus (handoff `Stepper`, size `sm`).
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
    this.min = 0,
    this.max = 99,
  });

  final int value;

  /// Called with [value] minus or plus one, kept within [min] and [max].
  final ValueChanged<int> onChanged;

  /// What the buttons do, for screen readers.
  final String decreaseLabel;
  final String increaseLabel;

  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: DSSizes.buttonHeightXxs,
            ),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: DSTypography.bodySmSemibold.copyWith(
                color: colors.textPrimary,
                // Digits of one width: the buttons do not shift as it counts.
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          _StepButton(
            icon: PhosphorIcons.plus(),
            label: increaseLabel,
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
    required this.onTap,
  });

  final IconData icon;
  final String label;

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
          dimension: DSSizes.buttonHeightXxs,
          child: Icon(
            icon,
            size: DSSizes.iconSm,
            color: onTap != null ? colors.textPrimary : colors.textDisabled,
          ),
        ),
      ),
    );
  }
}
