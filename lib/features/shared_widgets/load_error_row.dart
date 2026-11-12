import 'package:flutter/material.dart';

import '../../design_system/ds_extensions.dart';
import '../../l10n/generated/app_localizations.dart';

/// What a block shows in place of its content when the load failed: the
/// generic error text and a button that repeats the load.
class LoadErrorRow extends StatelessWidget {
  const LoadErrorRow({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.errorGeneric,
            style: DSTypography.body.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(width: DSSpacing.sm),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            foregroundColor: colors.brandPrimary,
            textStyle: DSTypography.bodySemibold,
          ),
          child: Text(l10n.retry),
        ),
      ],
    );
  }
}
