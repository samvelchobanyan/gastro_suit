import 'package:flutter/material.dart';

import '../../design_system/components/buttons/ds_button.dart';
import '../../design_system/ds_extensions.dart';

/// A whole screen saying that something went well (handoff
/// `PurchaseSuccess`, `WalletTopupSuccess`): a check and a [title] on a
/// panel, [details] under it, and one button at the bottom.
class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.details = const [],
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  /// What else to say, under the panel.
  final List<Widget> details;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DSSpacing.base,
                    vertical: DSSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DSSpacing.base,
                          vertical: DSSpacing.xl,
                        ),
                        decoration: BoxDecoration(
                          color: colors.bgCanvas,
                          borderRadius: BorderRadius.circular(DSRadius.md),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/success_check.png',
                              width: DSSizes.successImage,
                              height: DSSizes.successImage,
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(height: DSSpacing.base),
                            Semantics(
                              header: true,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: DSTypography.h1.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: DSSpacing.lg),
                        ...details,
                      ],
                    ],
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.bgSurface,
                border: Border(
                  top: BorderSide(
                    color: colors.borderMuted,
                    width: DSSizes.borderWidthDefault,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(DSSpacing.base),
                child: DSButton(
                  label: actionLabel,
                  size: DSButtonSize.sm,
                  fullWidth: true,
                  onPressed: onAction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
