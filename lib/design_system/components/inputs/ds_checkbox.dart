import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// A checkbox mark: a square, filled with a tick when checked (handoff
/// `Checkbox`). Visual only: the row it sits in takes the tap and reports
/// the state to screen readers.
class DSCheckbox extends StatelessWidget {
  const DSCheckbox({super.key, required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: DSSizes.checkbox,
      height: DSSizes.checkbox,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? colors.brandPrimary : colors.bgMain,
        borderRadius: BorderRadius.circular(DSRadius.checkbox),
        border: checked
            ? null
            : Border.all(
                color: colors.borderStrong,
                width: DSSizes.borderWidthThick,
              ),
      ),
      child: checked
          ? Icon(
              PhosphorIcons.check(PhosphorIconsStyle.bold),
              size: DSSizes.iconXs,
              color: colors.textOnBrand,
            )
          : null,
    );
  }
}
