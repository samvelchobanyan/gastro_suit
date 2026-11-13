import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/components/layout/ds_section_header.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/menu_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../menu/product_sheet/product_sheet.dart';
import '../../../shared_widgets/product_card.dart';

/// The products a branch features, in a sideways rail over its menu.
///
/// Reads the same menu as the `MenuBlock` under it and shows nothing until
/// that menu is there: the block shows the loading and the error for both.
class FeaturedProductsRail extends ConsumerWidget {
  const FeaturedProductsRail({super.key, required this.branchId});

  final String branchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(menuProvider(branchId)).value?.featured;
    if (featured == null || featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DSLayout.margin,
            0,
            DSLayout.margin,
            DSSpacing.base,
          ),
          child: DSSectionHeader(
            title: AppLocalizations.of(context).featuredProducts,
          ),
        ),
        SizedBox(
          height: ProductCard.heightFor(
            DSSizes.productRailCardWidth,
            MediaQuery.textScalerOf(context),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
            itemCount: featured.length,
            separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
            itemBuilder: (_, i) => SizedBox(
              width: DSSizes.productRailCardWidth,
              child: ProductCard(
                product: featured[i],
                onTap: () => showProduct(
                  context,
                  branchId: branchId,
                  productId: featured[i].id,
                ),
                onAdd: () => quickAddProduct(
                  context,
                  ref,
                  branchId: branchId,
                  product: featured[i],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: DSSpacing.lg),
      ],
    );
  }
}
