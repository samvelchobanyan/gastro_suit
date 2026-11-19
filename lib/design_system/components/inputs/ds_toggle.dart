import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// An on/off switch (handoff `Toggle`): a pill with a knob that slides to
/// the end when on.
class DSToggle extends StatelessWidget {
  const DSToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// What the switch turns on, for screen readers.
  final String semanticLabel;

  static const _knob = DSSizes.iconSm;
  static const _inset = DSSpacing.xxs;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : DSMotion.fast;
    return Semantics(
      toggled: value,
      label: semanticLabel,
      onTap: () => onChanged(!value),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: duration,
          curve: DSMotion.standard,
          width: _knob * 2 + _inset * 2,
          height: _knob + _inset * 2,
          padding: const EdgeInsets.all(_inset),
          decoration: BoxDecoration(
            color: value ? colors.brandPrimary : colors.borderDefault,
            borderRadius: BorderRadius.circular(DSRadius.pill),
          ),
          child: AnimatedAlign(
            duration: duration,
            curve: DSMotion.standard,
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              width: _knob,
              height: _knob,
              decoration: BoxDecoration(
                color: colors.bgSurface,
                shape: BoxShape.circle,
                boxShadow: DSElevation.card,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
