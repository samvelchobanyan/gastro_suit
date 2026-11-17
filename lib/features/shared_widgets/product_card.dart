import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/buttons/ds_icon_button.dart';
import '../../design_system/components/image/ds_network_image.dart';
import '../../design_system/components/inputs/ds_stepper.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/product.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/utils/price_format.dart';

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
    this.onAdd,
    this.onRemove,
  });

  final Product product;
  final VoidCallback? onTap;

  /// How many pieces of the product the cart holds.
  final int quantity;

  /// With a handler the photo carries the way to the cart
  /// (`ProductCartControl`). A product the branch has stopped never shows
  /// it.
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  /// The height of a card [width] wide: its square photo and two lines of
  /// text, at the user's text size.
  static double heightFor(double width, TextScaler textScaler) =>
      width + DSSpacing.sm + productCardTextHeight(textScaler);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onAdd = product.isAvailable ? this.onAdd : null;

    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DSRadius.card),
              child: ProductPhoto(url: product.imageUrl),
            ),
            if (onAdd != null)
              PositionedDirectional(
                end: DSSpacing.xs,
                bottom: DSSpacing.xs,
                child: ProductCartControl(
                  quantity: quantity,
                  plusSize: DSIconButtonSize.sm,
                  onAdd: onAdd,
                  onRemove: onRemove,
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
        opacity: product.isAvailable ? 1 : DSOpacity.disabled,
        child: card,
      ),
    );
  }
}

/// The way to the cart on a product card's photo: a plus while the cart
/// holds none of the product, a stepper with [quantity] once it does.
///
/// Keeps no number of its own. What a plus does is its owner's: a product
/// with choices is opened to choose, one without is added.
class ProductCartControl extends StatelessWidget {
  const ProductCartControl({
    super.key,
    required this.quantity,
    required this.plusSize,
    required this.onAdd,
    this.onRemove,
  });

  final int quantity;

  /// The size of the plus shown alone.
  final DSIconButtonSize plusSize;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (quantity < 1) {
      return DSIconButton(
        icon: PhosphorIcons.plus(),
        semanticLabel: l10n.addToCart,
        variant: DSIconButtonVariant.filled,
        size: plusSize,
        onPressed: onAdd,
      );
    }
    return DSStepper(
      value: quantity,
      onChanged: (value) => value > quantity ? onAdd() : onRemove?.call(),
      decreaseLabel: l10n.quantityDecrease,
      increaseLabel: l10n.quantityIncrease,
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
