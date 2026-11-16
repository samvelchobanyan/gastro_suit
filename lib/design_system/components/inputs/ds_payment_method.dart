import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// One way to pay, as a row (handoff `PaymentMethods`): an icon on a dark
/// tile, the name, and a caret when the row opens a list to choose from.
///
/// The handoff's trailing balance is not built: no way to pay shown so far
/// has one.
class DSPaymentMethod extends StatelessWidget {
  const DSPaymentMethod({
    super.key,
    required this.icon,
    required this.name,
    this.showCaret = false,
    required this.onTap,
  });

  final IconData icon;
  final String name;

  /// The row opens a list of ways to pay.
  final bool showCaret;

  /// Null: the row is dimmed and takes no taps.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: enabled ? 1 : DSOpacity.disabled,
          child: Container(
            padding: const EdgeInsets.all(DSSpacing.sm),
            decoration: BoxDecoration(
              color: colors.bgCanvas,
              borderRadius: BorderRadius.circular(DSRadius.md),
            ),
            child: Row(
              children: [
                Container(
                  width: DSSizes.buttonHeightXxs,
                  height: DSSizes.buttonHeightXxs,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.bgInverse,
                    borderRadius: BorderRadius.circular(DSRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    size: DSSizes.iconSm,
                    color: colors.textInverse,
                  ),
                ),
                const SizedBox(width: DSSpacing.md),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (showCaret) ...[
                  const SizedBox(width: DSSpacing.md),
                  Icon(
                    PhosphorIcons.caretDown(),
                    size: DSSizes.iconSm,
                    color: colors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
