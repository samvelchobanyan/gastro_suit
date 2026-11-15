import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/components/layout/ds_section_header.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/menu_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../widgets/product_cards_rail.dart';
import '../product_sheet.dart';

/// "Anything else?" at the end of a product's sheet: the products the
/// merchant suggests with it, in a sideways rail.
///
/// Takes no room until there is something to suggest: while the list
/// loads, when it is empty and when it failed to load.
class RecommendedProductsRail extends ConsumerWidget {
  const RecommendedProductsRail({
    super.key,
    required this.branchId,
    required this.productId,
  });

  final String branchId;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref
        .watch(
          recommendedProductsProvider((
            branchId: branchId,
            productId: productId,
          )),
        )
        .value;
    if (products == null || products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: DSSpacing.lg, bottom: DSSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
            child: DSSectionHeader(
              title: AppLocalizations.of(context).productAnythingElse,
            ),
          ),
          const SizedBox(height: DSSpacing.md),
          ProductCardsRail(
            products: products,
            // Over this sheet: closing it comes back to this product.
            onTap: (product) =>
                showProduct(context, branchId: branchId, productId: product.id),
            onAdd: (product) => quickAddProduct(
              context,
              ref,
              branchId: branchId,
              product: product,
            ),
          ),
          const SizedBox(height: DSSpacing.xs),
        ],
      ),
    );
  }
}
