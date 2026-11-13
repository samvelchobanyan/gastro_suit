import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/components/inputs/ds_stepper.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/cart.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../shared_widgets/price_text.dart';

/// One line of the cart (handoff `ProductBasket`): the product's photo,
/// name, what was chosen for it and the price of one; under them a button
/// that removes the line and the quantity.
///
/// A line the branch cannot make now is dimmed and says so; it can only be
/// removed.
class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.line,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartLine line;

  /// Called with the quantity asked for, never below 1.
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  /// The most of one line.
  static const _maxQuantity = 99;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final choice = line.choice;
    final chosen = [
      if (choice.size case final size?) size.name,
      for (final option in choice.options) option.name,
    ].join(' · ');

    final product = Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(DSRadius.md),
          child: DSNetworkImage(
            url: line.imageUrl,
            width: DSSizes.cartLineImage,
            height: DSSizes.cartLineImage,
          ),
        ),
        const SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                choice.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.bodySemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (chosen.isNotEmpty) ...[
                const SizedBox(height: DSSpacing.xxs),
                Text(
                  chosen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.body.copyWith(color: colors.textTertiary),
                ),
              ],
              const SizedBox(height: DSSpacing.xxs),
              Text(
                formatPrice(context, line.unitPrice),
                style: DSTypography.bodySm.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: colors.bgCanvas,
        borderRadius: BorderRadius.circular(DSRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Opacity(
            opacity: line.isAvailable ? 1 : DSOpacity.disabled,
            child: product,
          ),
          if (!line.isAvailable) ...[
            const SizedBox(height: DSSpacing.sm),
            Text(
              l10n.cartLineUnavailable,
              style: DSTypography.bodySm.copyWith(color: colors.textError),
            ),
          ],
          const SizedBox(height: DSSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DSIconButton(
                icon: PhosphorIcons.trash(),
                semanticLabel: l10n.cartLineRemove,
                variant: DSIconButtonVariant.tonal,
                size: DSIconButtonSize.xs,
                onPressed: onRemove,
              ),
              if (line.isAvailable)
                DSStepper(
                  value: line.quantity,
                  min: 1,
                  max: _maxQuantity,
                  onChanged: onQuantityChanged,
                  decreaseLabel: l10n.quantityDecrease,
                  increaseLabel: l10n.quantityIncrease,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
