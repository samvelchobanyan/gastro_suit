import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// A rating as five stars, to the half star (handoff `RatingStars`, display
/// only). Zero shows five empty stars.
class DSRatingStars extends StatelessWidget {
  const DSRatingStars({
    super.key,
    required this.value,
    this.size = DSSizes.iconXs,
  });

  /// 0 to 5.
  final double value;
  final double size;

  static const _count = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: DSSpacing.xxs,
        children: [
          for (var i = 0; i < _count; i++)
            if (value >= i + 1)
              Icon(
                PhosphorIcons.star(PhosphorIconsStyle.fill),
                size: size,
                color: colors.statusWarning,
              )
            else if (value >= i + 0.5)
              Icon(
                PhosphorIcons.starHalf(PhosphorIconsStyle.fill),
                size: size,
                color: colors.statusWarning,
              )
            else
              Icon(
                PhosphorIcons.star(),
                size: size,
                color: colors.borderStrong,
              ),
        ],
      ),
    );
  }
}
