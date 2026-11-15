import 'package:flutter/material.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/product.dart';
import '../../shared_widgets/product_card.dart';

/// Product cards in a row that scrolls sideways from one edge of the
/// screen to the other, the first card at the screen's margin.
///
/// Only the row: whoever shows it puts its title over it and the gaps
/// around it.
class ProductCardsRail extends StatelessWidget {
  const ProductCardsRail({
    super.key,
    required this.products,
    required this.onTap,
    required this.onAdd,
  });

  final List<Product> products;
  final ValueChanged<Product> onTap;

  /// The plus on a card's photo.
  final ValueChanged<Product> onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ProductCard.heightFor(
        DSSizes.productRailCardWidth,
        MediaQuery.textScalerOf(context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
        itemBuilder: (_, i) => SizedBox(
          width: DSSizes.productRailCardWidth,
          child: ProductCard(
            product: products[i],
            onTap: () => onTap(products[i]),
            onAdd: () => onAdd(products[i]),
          ),
        ),
      ),
    );
  }
}
