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

/// A short text on a small dark capsule, laid over a picture (handoff
/// `BadgeCounter`): how many more there are ("+3").
class DSBadgeCounter extends StatelessWidget {
  const DSBadgeCounter({super.key, required this.label});

  final String label;

  static const _height = DSSizes.iconXs + DSSpacing.xxs;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: _height, minHeight: _height),
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.bgInverse,
        borderRadius: BorderRadius.circular(DSRadius.full),
      ),
      child: Text(
        label,
        style: DSTypography.bodyXs.copyWith(
          color: colors.textInverse,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
