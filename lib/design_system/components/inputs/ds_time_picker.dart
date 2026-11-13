import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One time a [DSTimePicker] offers: what it stands for and how it reads.
class DSTimeSlot<T> {
  const DSTimeSlot({required this.value, required this.label});

  final T value;
  final String label;
}

/// A row of times to pick one from (handoff `TimePicker`): pills side by
/// side, the picked one in the brand colour. As wide as its pills: a
/// screen with more of them than fit scrolls the row sideways.
///
/// Keeps no time of its own: it shows [value] and reports the one tapped.
class DSTimePicker<T> extends StatelessWidget {
  const DSTimePicker({
    super.key,
    required this.slots,
    required this.value,
    required this.onChanged,
  });

  final List<DSTimeSlot<T>> slots;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, slot) in slots.indexed) ...[
          if (i > 0) const SizedBox(width: DSSpacing.sm),
          Semantics(
            button: true,
            selected: slot.value == value,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(slot.value),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: DSSizes.buttonHeightLg,
                ),
                height: DSSizes.buttonHeightSm,
                padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: slot.value == value
                      ? colors.brandSubtle
                      : colors.bgMain,
                  borderRadius: BorderRadius.circular(DSRadius.full),
                  border: Border.all(
                    color: slot.value == value
                        ? colors.brandPrimary
                        : colors.borderDefault,
                    width: DSSizes.borderWidthDefault,
                  ),
                ),
                child: Text(
                  slot.label,
                  style: DSTypography.bodySmSemibold.copyWith(
                    color: slot.value == value
                        ? colors.textAccent
                        : colors.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
