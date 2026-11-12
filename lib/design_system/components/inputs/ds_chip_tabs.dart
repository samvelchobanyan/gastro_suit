import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../ds_extensions.dart';

/// One chip of a [DSChipTabs]: the value it stands for and its text.
class DSChipTab<T> {
  const DSChipTab({required this.value, required this.label});

  final T value;
  final String label;
}

/// A row of compact chips, one of them selected (handoff `TabBar`, size
/// `xs`). Scrolls sideways when the chips do not fit.
///
/// The selected chip is kept in view: when the selection changes to a chip
/// that is off the row's edge, wholly or in part, the row scrolls just far
/// enough to show it. A chip already in view does not move the row.
class DSChipTabs<T> extends StatefulWidget {
  const DSChipTabs({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.padding = EdgeInsets.zero,
  });

  final List<DSChipTab<T>> options;

  /// The selected option's value; none is selected when no option has it.
  final T? value;
  final ValueChanged<T> onChanged;

  /// Space around the chips inside the scrolling row, so that the row can
  /// run edge to edge while the chips start at the screen margin.
  final EdgeInsets padding;

  @override
  State<DSChipTabs<T>> createState() => _DSChipTabsState<T>();
}

class _DSChipTabsState<T> extends State<DSChipTabs<T>> {
  final _controller = ScrollController();
  final _selectedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _showSelectedAfterFrame(animate: false);
  }

  @override
  void didUpdateWidget(DSChipTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _showSelectedAfterFrame(animate: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The chips are measured once the frame with the new selection is laid
  /// out.
  void _showSelectedAfterFrame({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showSelected(animate: animate);
    });
  }

  /// Scrolls the row, and only the row, until the selected chip is wholly
  /// in view with the row's padding beside it.
  void _showSelected({required bool animate}) {
    final chip = _selectedKey.currentContext?.findRenderObject();
    if (chip == null || !_controller.hasClients) return;
    final position = _controller.position;
    final viewport = RenderAbstractViewport.of(chip);

    // The chip is in view while the row is scrolled between these two.
    final atStart =
        viewport.getOffsetToReveal(chip, 0).offset - widget.padding.left;
    final atEnd =
        viewport.getOffsetToReveal(chip, 1).offset + widget.padding.right;
    final double target;
    if (position.pixels > atStart) {
      target = atStart;
    } else if (position.pixels < atEnd) {
      target = atEnd;
    } else {
      return;
    }

    final clamped = target.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (!animate || MediaQuery.disableAnimationsOf(context)) {
      position.jumpTo(clamped);
    } else {
      position.animateTo(
        clamped,
        duration: DSMotion.base,
        curve: DSMotion.standard,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: widget.padding,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: DSSpacing.sm),
            _Chip(
              key: options[i].value == widget.value ? _selectedKey : null,
              label: options[i].label,
              selected: options[i].value == widget.value,
              onTap: () => widget.onChanged(options[i].value),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
