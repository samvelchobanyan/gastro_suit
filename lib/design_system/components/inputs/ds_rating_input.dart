import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// Five stars to give a rating with (handoff `RatingStars`, not read-only):
/// a tap on a star gives that many. Whole stars only.
///
/// Keeps no rating of its own: it shows [value] and reports the one the
/// user tapped; whoever owns the rating passes it back. A separate
/// component from `DSRatingStars`, which only shows a rating.
class DSRatingInput extends StatelessWidget {
  const DSRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.starLabel,
  });

  /// 0 to 5; zero is no rating yet, five empty stars.
  final int value;

  /// Called with the number of the tapped star, 1 to 5.
  final ValueChanged<int> onChanged;

  /// What a star gives, for screen readers ("3 of 5").
  final String Function(int star) starLabel;

  static const _count = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: DSSpacing.xs,
      children: [
        for (var star = 1; star <= _count; star++)
          Semantics(
            button: true,
            selected: star == value,
            label: starLabel(star),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(star),
              child: Padding(
                padding: const EdgeInsets.all(DSSpacing.xxs),
                child: star <= value
                    ? Icon(
                        PhosphorIcons.star(PhosphorIconsStyle.fill),
                        size: DSSizes.iconLg,
                        color: colors.statusWarning,
                      )
                    : Icon(
                        PhosphorIcons.star(),
                        size: DSSizes.iconLg,
                        color: colors.borderStrong,
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
