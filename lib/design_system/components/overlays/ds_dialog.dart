import 'package:flutter/material.dart';

import '../../ds_extensions.dart';
import '../buttons/ds_button.dart';

/// Asks the user to confirm an action in a [DSDialog] over the whole app.
/// True when confirmed; false when cancelled or dismissed.
Future<bool> showDSConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierColor: context.colors.bgScrim,
    builder: (context) => DSDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: () => Navigator.pop(context, true),
      onCancel: () => Navigator.pop(context, false),
    ),
  );
  return confirmed ?? false;
}

/// A centred card with a question and two answers (handoff `Dialog`): the
/// title, a sentence under it, then cancel and confirm side by side.
/// Opened with [showDSConfirmDialog].
class DSDialog extends StatelessWidget {
  const DSDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DSSizes.dialogMaxWidth),
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            namesRoute: true,
            label: title,
            child: Material(
              type: MaterialType.transparency,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.bgSurface,
                  borderRadius: BorderRadius.circular(DSRadius.dialog),
                  boxShadow: DSElevation.overlay,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(DSSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: DSTypography.h2.copyWith(
                          fontWeight: DSTypography.semibold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DSSpacing.sm),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: DSTypography.bodyLg.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: DSSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: DSButton(
                              label: cancelLabel,
                              variant: DSButtonVariant.secondary,
                              size: DSButtonSize.md,
                              fullWidth: true,
                              onPressed: onCancel,
                            ),
                          ),
                          const SizedBox(width: DSSpacing.md),
                          Expanded(
                            child: DSButton(
                              label: confirmLabel,
                              size: DSButtonSize.md,
                              fullWidth: true,
                              onPressed: onConfirm,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
