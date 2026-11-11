import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// A radio mark: a ring, with a dot when selected (handoff `RadioButton`).
/// Visual only: the row it sits in takes the tap and reports the state to
/// screen readers.
class DSRadio extends StatelessWidget {
  const DSRadio({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: DSSizes.radio,
      height: DSSizes.radio,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.bgMain,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.brandPrimary : colors.borderStrong,
          width: DSSizes.borderWidthThick,
        ),
      ),
      child: selected
          ? Container(
              width: DSSizes.radioDot,
              height: DSSizes.radioDot,
              decoration: BoxDecoration(
                color: colors.brandPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
