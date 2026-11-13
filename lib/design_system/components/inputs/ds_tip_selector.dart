import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One amount of a row of tips (handoff `TipSelector`): a tile with a
/// label, in the brand colour when it is the chosen one. As wide as its
/// parent makes it, and no narrower than [DSSizes.tipSelectorMinWidth].
class DSTipSelector extends StatelessWidget {
  const DSTipSelector({
    super.key,
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
          constraints: const BoxConstraints(
            minWidth: DSSizes.tipSelectorMinWidth,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.sm,
            vertical: DSSpacing.md,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.brandSubtle : colors.bgMain,
            borderRadius: BorderRadius.circular(DSRadius.md),
            border: Border.all(
              color: selected ? colors.brandPrimary : colors.borderDefault,
              width: DSSizes.borderWidthDefault,
            ),
          ),
          child: Text(
            label,
            style: DSTypography.bodySmSemibold.copyWith(
              color: selected ? colors.textAccent : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
