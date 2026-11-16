import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../design_system/components/buttons/ds_button.dart';
import '../../../../design_system/components/inputs/ds_stepper.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../product_selection_controller.dart';

/// The bar under the product sheet's scrolling content: how many, and the
/// button that adds them to the cart, with what they cost together.
///
/// While a cart line is being changed ([editing]) the button saves the
/// line instead.
class ProductAddBar extends StatelessWidget {
  const ProductAddBar({
    super.key,
    required this.selection,
    required this.onQuantityChanged,
    required this.busy,
    required this.error,
    required this.editing,
    required this.onSubmit,
  });

  final ProductSelection selection;
  final ValueChanged<int> onQuantityChanged;

  /// The request is under way: the button shows it and the quantity takes
  /// no taps.
  final bool busy;

  /// Why the last request was not accepted, shown over the controls.
  final String? error;

  /// A cart line is being changed: the button saves instead of adding.
  final bool editing;

  /// Called by the button, which takes taps only for a complete selection.
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final total = formatPrice(context, selection.total);
    return DecoratedBox(
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
        padding: EdgeInsets.fromLTRB(
          DSSpacing.base,
          DSSpacing.base,
          DSSpacing.base,
          DSSpacing.base + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error case final error?) ...[
              Text(
                error,
                style: DSTypography.bodySm.copyWith(color: colors.textError),
              ),
              const SizedBox(height: DSSpacing.sm),
            ],
            Row(
              children: [
                IgnorePointer(
                  ignoring: busy,
                  child: DSStepper(
                    size: DSStepperSize.md,
                    value: selection.quantity,
                    min: 1,
                    max: ProductSelectionController.maxQuantity,
                    onChanged: onQuantityChanged,
                    decreaseLabel: l10n.quantityDecrease,
                    increaseLabel: l10n.quantityIncrease,
                  ),
                ),
                const SizedBox(width: DSSpacing.sm),
                Expanded(
                  child: DSButton(
                    label: editing
                        ? l10n.saveWithTotal(total)
                        : l10n.addWithTotal(total),
                    icon: editing ? null : PhosphorIcons.shoppingCartSimple(),
                    size: DSButtonSize.sm,
                    fullWidth: true,
                    loading: busy,
                    onPressed: selection.isComplete ? onSubmit : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
