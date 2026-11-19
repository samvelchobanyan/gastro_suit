import 'package:flutter/material.dart';

import '../../design_system/ds_extensions.dart';
import 'load_error_row.dart';

/// What a screen shows in place of its list: a spinner while it
/// loads, the way to try again when it failed, [emptyText] when there is
/// nothing to list.
class ListPlaceholder extends StatelessWidget {
  const ListPlaceholder.loading({super.key}) : onRetry = null, emptyText = null;

  const ListPlaceholder.failed({super.key, required VoidCallback this.onRetry})
    : emptyText = null;

  const ListPlaceholder.empty({super.key, required String this.emptyText})
    : onRetry = null;

  final VoidCallback? onRetry;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onRetry = this.onRetry;
    final emptyText = this.emptyText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
      child: onRetry != null
          ? Align(
              alignment: Alignment.topCenter,
              child: LoadErrorRow(onRetry: onRetry),
            )
          : emptyText != null
          ? Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                emptyText,
                style: DSTypography.body.copyWith(color: colors.textTertiary),
              ),
            )
          : const Align(alignment: Alignment.topCenter, child: ListSpinner()),
    );
  }
}

/// The sign that more of a list is on its way.
class ListSpinner extends StatelessWidget {
  const ListSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: SizedBox(
        width: DSSizes.iconMd,
        height: DSSizes.iconMd,
        child: CircularProgressIndicator(
          strokeWidth: DSSizes.borderWidthThick,
          color: context.colors.brandPrimary,
        ),
      ),
    );
  }
}
