import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// The title at the top of a screen (handoff `ScreenHeader`), with the back
/// arrow before it on a screen that was opened over another. The handoff's
/// trailing action is added when a screen needs it.
class DSScreenHeader extends StatelessWidget {
  const DSScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.backLabel,
  });

  final String title;

  /// Null on a screen with nothing to go back to: no arrow is shown.
  final VoidCallback? onBack;

  /// What the arrow does, for screen readers; given with [onBack].
  final String? backLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onBack = this.onBack;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        // The arrow's own room reaches into the margin, so that its glyph
        // stands where the margin ends.
        onBack == null ? DSSpacing.base : DSSpacing.sm,
        DSSpacing.base,
        DSSpacing.base,
        DSSpacing.base,
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            Semantics(
              button: true,
              label: backLabel,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBack,
                child: SizedBox(
                  width: DSSizes.headerAction,
                  height: DSSizes.headerAction,
                  child: Icon(
                    PhosphorIcons.arrowLeft(),
                    size: DSSizes.iconMd,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: DSSpacing.sm),
          ],
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.h1.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
