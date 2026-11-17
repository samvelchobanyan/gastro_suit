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
    required this.quantities,
    required this.onAdd,
    required this.onRemove,
  });

  final List<Product> products;
  final ValueChanged<Product> onTap;

  /// How many pieces of a product the cart holds, by the product's id.
  final Map<String, int> quantities;

  /// The plus and the minus on a card's photo.
  final ValueChanged<Product> onAdd;
  final ValueChanged<Product> onRemove;

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
            quantity: quantities[products[i].id] ?? 0,
            onAdd: () => onAdd(products[i]),
            onRemove: () => onRemove(products[i]),
          ),
        ),
      ),
    );
  }
}
