import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/product.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/price_text.dart';
import '../../shared_widgets/product_card.dart';

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
    this.onAdd,
  });

  final Product product;
  final VoidCallback? onTap;

  /// With a handler the photo carries a plus that adds the product to the
  /// cart. The plus stays a plus: what the cart holds is seen in the cart.
  /// A product the branch has stopped never shows it.
  final VoidCallback? onAdd;

  /// The height of a card [width] wide: its square photo and two lines of
  /// text with their padding, at the user's text size.
  static double heightFor(double width, TextScaler textScaler) =>
      width + DSSpacing.sm * 2 + productCardTextHeight(textScaler);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final onAdd = product.isAvailable ? this.onAdd : null;

    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ProductPhoto(url: product.imageUrl),
            if (onAdd != null)
              PositionedDirectional(
                end: DSSpacing.sm,
                bottom: DSSpacing.sm,
                child: DSIconButton(
                  icon: PhosphorIcons.plus(),
                  semanticLabel: l10n.addToCart,
                  variant: DSIconButtonVariant.filled,
                  size: DSIconButtonSize.xs,
                  onPressed: onAdd,
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
        opacity: product.isAvailable ? 1 : DSOpacity.disabled,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DSRadius.md),
          child: ColoredBox(color: colors.bgInverse, child: card),
        ),
      ),
    );
  }
}
