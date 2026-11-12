import 'package:flutter/material.dart';

import '../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/product.dart';
import '../../shared_widgets/price_text.dart';
import '../../shared_widgets/product_card.dart';
import '../../shared_widgets/product_quantity_button.dart';

/// A product in the menu grid (handoff `ProductMenuCard`): a dark card with
/// the photo on top and the name and the price under it. As wide as its
/// parent makes it; see [heightFor].
///
/// Rails have their own card, `ProductCard`.
class MenuProductCard extends StatelessWidget {
  const MenuProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.quantity = 0,
    this.onQuantityChanged,
  });

  final Product product;
  final VoidCallback? onTap;

  /// How many of the product the cart holds.
  final int quantity;

  /// With a handler the photo carries the add control: a plus, or a stepper
  /// once [quantity] is above zero. A product the branch has stopped never
  /// shows it.
  final ValueChanged<int>? onQuantityChanged;

  /// The height of a card [width] wide: its square photo and two lines of
  /// text with their padding, at the user's text size.
  static double heightFor(double width, TextScaler textScaler) =>
      width + DSSpacing.sm * 2 + productCardTextHeight(textScaler);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onQuantityChanged = product.isAvailable
        ? this.onQuantityChanged
        : null;

    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ProductPhoto(url: product.imageUrl),
            if (onQuantityChanged != null)
              PositionedDirectional(
                end: DSSpacing.sm,
                bottom: DSSpacing.sm,
                child: ProductQuantityButton(
                  quantity: quantity,
                  onChanged: onQuantityChanged,
                  addButtonSize: DSIconButtonSize.xs,
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(DSSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.bodySmSemibold.copyWith(
                  color: colors.textInverse,
                ),
              ),
              const SizedBox(height: DSSpacing.xxs),
              Text(
                formatPrice(context, product.price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.bodyXs.copyWith(color: colors.textInverse),
              ),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: product.isAvailable ? 1 : DSColors.disabledOpacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DSRadius.md),
          child: ColoredBox(color: colors.bgInverse, child: card),
        ),
      ),
    );
  }
}
