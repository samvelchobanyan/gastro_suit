import 'package:flutter/material.dart';

import '../../ds_extensions.dart';
import 'ds_option.dart';

/// A row of compact chips, one of them selected (handoff `TabBar`, size
/// `xs`). Scrolls sideways when the chips do not fit.
class DSChipTabs<T> extends StatelessWidget {
  const DSChipTabs({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<DSOption<T>> options;

  /// The selected option's value; none is selected when no option has it.
  final T? value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: DSSpacing.sm),
            _Chip(
              label: options[i].label,
              selected: options[i].value == value,
              onTap: () => onChanged(options[i].value),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: DSSizes.buttonHeightXs),
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.bgMain : colors.bgSurfaceSunken,
            borderRadius: BorderRadius.circular(DSRadius.full),
            border: selected
                ? Border.all(
                    color: colors.brandPrimary,
                    width: DSSizes.borderWidthDefault,
                  )
                : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            style: DSTypography.bodySmSemibold.copyWith(
              color: selected ? colors.textAccent : colors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
