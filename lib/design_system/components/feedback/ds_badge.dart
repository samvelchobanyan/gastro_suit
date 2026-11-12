import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// A count on a small brand-tinted capsule (handoff `Badge`, variant
/// `empty`). The handoff's red variant is added when a screen uses it.
class DSBadge extends StatelessWidget {
  const DSBadge({super.key, required this.count});

  final int count;

  /// Larger counts are shown as "99+".
  static const _max = 99;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(
        minWidth: DSSizes.badge,
        minHeight: DSSizes.badge,
      ),
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.brandSubtle,
        borderRadius: BorderRadius.circular(DSRadius.full),
        border: Border.all(
          color: colors.brandPrimary,
          width: DSSizes.borderWidthDefault,
        ),
      ),
      child: Text(
        count > _max ? '$_max+' : '$count',
        style: DSTypography.bodyXs.copyWith(
          fontWeight: DSTypography.semibold,
          color: colors.textAccent,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
