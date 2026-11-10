import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// The pill's colour: what kind of state it reports.
enum DSStatusTone { success, error }

/// A short state label on a soft tonal capsule: Open / Closed and the like
/// (handoff `StatusPill`). Tones are added as screens need them.
class DSStatusPill extends StatelessWidget {
  const DSStatusPill({super.key, required this.label, required this.tone});

  final String label;
  final DSStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      DSStatusTone.success => (colors.bgSuccess, colors.textSuccess),
      DSStatusTone.error => (colors.bgError, colors.textError),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DSRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.sm,
          vertical: DSSpacing.xxs,
        ),
        child: Text(
          label,
          style: DSTypography.bodyXs.copyWith(
            fontWeight: DSTypography.bold,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
