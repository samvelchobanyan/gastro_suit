import 'package:flutter/material.dart';

import '../../design_system/components/buttons/ds_icon_button.dart';
import '../../design_system/components/image/ds_network_image.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/product.dart';
import 'price_text.dart';
import 'product_quantity_button.dart';

/// A product in a sideways rail (handoff `ProductVerticalCard`): a rounded
/// photo with the name and the price under it. As wide as its parent makes
/// it; see [heightFor].
///
/// The menu grid has its own card, `MenuProductCard`.
class ProductCard extends StatelessWidget {
  const ProductCard({
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
  /// text, at the user's text size.
  static double heightFor(double width, TextScaler textScaler) =>
      width + DSSpacing.sm + productCardTextHeight(textScaler);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(DSRadius.card),
              child: ProductPhoto(url: product.imageUrl),
            ),
            if (onQuantityChanged != null)
              PositionedDirectional(
                end: DSSpacing.xs,
                bottom: DSSpacing.xs,
                child: ProductQuantityButton(
                  quantity: quantity,
                  onChanged: onQuantityChanged,
                  addButtonSize: DSIconButtonSize.sm,
                ),
              ),
          ],
        ),
        const SizedBox(height: DSSpacing.sm),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DSTypography.bodySmSemibold.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: DSSpacing.xxs),
        Text(
          formatPrice(context, product.price),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DSTypography.bodyXs.copyWith(color: colors.textSecondary),
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: product.isAvailable ? 1 : DSColors.disabledOpacity,
        child: card,
      ),
    );
  }
}

/// A product's square photo, as wide as its parent.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => DSNetworkImage(
        url: url,
        width: constraints.maxWidth,
        height: constraints.maxWidth,
      ),
    );
  }
}

/// The height of a product card's two lines of text, the name and the
/// price with the gap between them, at the user's text size.
double productCardTextHeight(TextScaler textScaler) {
  double lineHeight(TextStyle style) =>
      (textScaler.scale(style.fontSize!) * style.height!).ceilToDouble();
  return lineHeight(DSTypography.bodySmSemibold) +
      DSSpacing.xxs +
      lineHeight(DSTypography.bodyXs);
}
