import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/portion_format.dart';
import '../../../../core/utils/price_format.dart';
import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// One favourite product (handoff `ProductFavorite`): its photo, name,
/// portion and price, which open the product, and the heart that takes it
/// out of the favourites.
class FavoriteProductTile extends StatelessWidget {
  const FavoriteProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onRemove,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    // With sizes the price is the smallest size's, and so is the portion.
    final portion = product.sizes.isEmpty
        ? product.portion
        : product.sizes.first.portion;

    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DSRadius.md),
                    child: DSNetworkImage(
                      url: product.imageUrl,
                      width: DSSizes.cartLineImage,
                      height: DSSizes.cartLineImage,
                    ),
                  ),
                  const SizedBox(width: DSSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: DSTypography.bodySemibold.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        if (portion != null) ...[
                          const SizedBox(height: DSSpacing.xxs),
                          Text(
                            formatPortion(context, portion),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DSTypography.body.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                        ],
                        const SizedBox(height: DSSpacing.xxs),
                        Text(
                          formatPrice(context, product.price),
                          style: DSTypography.bodySm.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: DSSpacing.md),
        DSIconButton(
          icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
          onPressed: onRemove,
          semanticLabel: l10n.favoriteRemove,
          variant: DSIconButtonVariant.ghost,
          size: DSIconButtonSize.sm,
          active: true,
        ),
      ],
    );
  }
}
