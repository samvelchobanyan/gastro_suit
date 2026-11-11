import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// One option of a [DSDropdown]: the value it stands for and its text.
class DSDropdownOption<T> {
  const DSDropdownOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A select box: a field showing the chosen option that opens a list of the
/// options below it (handoff `Dropdown`, 40 high).
///
/// The field and the list are drawn here; [RawMenuAnchor] places the list,
/// closes it on an outside tap or Escape, and handles focus.
class DSDropdown<T> extends StatefulWidget {
  const DSDropdown({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
  });

  final List<DSDropdownOption<T>> options;

  /// The chosen option's value: shown in the field and marked in the list.
  final T? value;
  final ValueChanged<T> onChanged;

  /// Shown when no option has [value].
  final String? placeholder;

  @override
  State<DSDropdown<T>> createState() => _DSDropdownState<T>();
}

class _DSDropdownState<T> extends State<DSDropdown<T>> {
  final _controller = MenuController();
  var _open = false;

  void _toggle() => _open ? _controller.close() : _controller.open();

  void _select(T value) {
    _controller.close();
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    DSDropdownOption<T>? selected;
    for (final option in widget.options) {
      if (option.value == widget.value) selected = option;
    }
    final text = selected?.label ?? widget.placeholder ?? '';

    return RawMenuAnchor(
      controller: _controller,
      onOpen: () => setState(() => _open = true),
      onClose: () => setState(() => _open = false),
      overlayBuilder: (context, info) => _Menu<T>(
        info: info,
        options: widget.options,
        value: widget.value,
        onSelect: _select,
      ),
      child: Semantics(
        button: true,
        expanded: _open,
        value: text,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: Container(
            height: DSSizes.inputHeightCompact,
            padding: const EdgeInsets.only(
              left: DSSpacing.base,
              right: DSSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.bgMain,
              borderRadius: BorderRadius.circular(DSRadius.input),
              border: Border.all(
                color: _open ? colors.borderInteractive : colors.borderDefault,
                width: _open
                    ? DSSizes.borderWidthFocus
                    : DSSizes.borderWidthDefault,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySm.copyWith(
                      color: selected != null
                          ? colors.textPrimary
                          : colors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: DSSpacing.sm),
                Icon(
                  _open ? PhosphorIcons.caretUp() : PhosphorIcons.caretDown(),
                  size: DSSizes.iconSm,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The open list, under the field and as wide as it.
class _Menu<T> extends StatelessWidget {
  const _Menu({
    required this.info,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final RawMenuOverlayInfo info;
  final List<DSDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final anchor = info.anchorRect;
    final top = anchor.bottom + DSSpacing.xs;
    // Stays on screen when the field is low.
    final room = info.overlaySize.height - top - DSSpacing.base;

    return Positioned(
      left: anchor.left,
      top: top,
      width: anchor.width,
      child: TapRegion(
        groupId: info.tapRegionGroupId,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: math.max(0, math.min(DSSizes.menuMaxHeight, room)),
            ),
            decoration: BoxDecoration(
              color: colors.bgSurface,
              borderRadius: BorderRadius.circular(DSRadius.input),
              border: Border.all(
                color: colors.borderMuted,
                width: DSSizes.borderWidthDefault,
              ),
              boxShadow: DSElevation.overlay,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(DSSpacing.xs),
              children: [
                for (final option in options)
                  _Item(
                    label: option.label,
                    selected: option.value == value,
                    onTap: () => onSelect(option.value),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
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
    final color = selected ? colors.textAccent : colors.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: DSSizes.menuItemHeight),
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.sm),
          decoration: BoxDecoration(
            color: selected ? colors.brandSubtle : null,
            borderRadius: BorderRadius.circular(DSRadius.sm),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: DSTypography.body.copyWith(color: color),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: DSSpacing.sm),
                Icon(PhosphorIcons.check(), size: DSSizes.iconSm, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
