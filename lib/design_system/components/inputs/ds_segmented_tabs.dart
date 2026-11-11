import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// One segment of a [DSSegmentedTabs]: the value it stands for, its text and
/// its icon.
class DSSegment<T> {
  const DSSegment({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}

/// A full-width switch between a few views of one screen (handoff `TabBar`,
/// size `big`): equal segments on a recessed track, with an indicator that
/// slides under the selected one.
class DSSegmentedTabs<T> extends StatelessWidget {
  const DSSegmentedTabs({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<DSSegment<T>> segments;

  /// The selected segment's value; the first is shown selected when no
  /// segment has it.
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final found = segments.indexWhere((s) => s.value == value);
    final index = found < 0 ? 0 : found;
    final count = segments.length;

    return Container(
      padding: const EdgeInsets.all(DSSpacing.xs),
      decoration: BoxDecoration(
        color: colors.bgSurfaceSunken,
        borderRadius: BorderRadius.circular(DSRadius.full),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              // From the first segment's place (-1) to the last one's (1).
              alignment: AlignmentDirectional(
                count > 1 ? index * 2 / (count - 1) - 1 : 0,
                0,
              ),
              // No slide when the system asks for reduced motion.
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : DSMotion.base,
              curve: DSMotion.standard,
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.bgMain,
                    borderRadius: BorderRadius.circular(DSRadius.full),
                    boxShadow: DSElevation.card,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < count; i++)
                Expanded(
                  child: _Segment(
                    label: segments[i].label,
                    icon: segments[i].icon,
                    selected: i == index,
                    onTap: () => onChanged(segments[i].value),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.textPrimary : colors.textTertiary;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: DSSizes.buttonHeightSm),
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: DSSizes.iconXs, color: color),
              const SizedBox(width: DSSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySemibold.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
