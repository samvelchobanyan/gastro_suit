import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/utils/error_text.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/state/active_branch_state.dart';
import '../../../domain/state/favorites_state.dart';
import '../../../domain/state/menu_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../menu/product_sheet/product_sheet.dart';
import '../../shared_widgets/list_placeholder.dart';
import 'widgets/favorite_product_tile.dart';

/// The user's favourite products as the active branch sells them, a line
/// between each two. Opened from the profile; covers the tab bar.
///
/// Shows what the app already holds — the favourites and the active
/// branch's menu — so it has no controller of its own. A favourite the
/// branch does not sell is not listed; one the branch has stopped is
/// listed as any other (DESIGN_PRODUCT_QUESTIONS §24).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    try {
      await ref.read(favoritesProvider.notifier).toggle(product.id);
    } on AppException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final favorites = ref.watch(favoritesProvider);
    final branch = ref.watch(activeBranchProvider);
    final branchId = branch.value?.id;
    final menu = branchId == null ? null : ref.watch(menuProvider(branchId));

    final ids = favorites.value;
    final offered = menu?.value?.products;
    final Widget body;
    if (ids == null || branchId == null || offered == null) {
      final failed =
          favorites.hasError || branch.hasError || (menu?.hasError ?? false);
      // Loaded without a branch: the organisation has none to sell from.
      final noBranch = branch.hasValue && branchId == null;
      body = failed
          ? ListPlaceholder.failed(
              onRetry: () {
                if (favorites.hasError) ref.invalidate(favoritesProvider);
                if (branch.hasError) ref.invalidate(activeBranchProvider);
                if (branchId != null) ref.invalidate(menuProvider(branchId));
              },
            )
          : noBranch
          ? ListPlaceholder.empty(emptyText: l10n.favoritesEmpty)
          : const ListPlaceholder.loading();
    } else {
      final products = [
        for (final product in offered)
          if (ids.contains(product.id)) product,
      ];
      body = products.isEmpty
          ? ListPlaceholder.empty(
              emptyText: ids.isEmpty
                  ? l10n.favoritesEmpty
                  : l10n.favoritesNoneAtBranch,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                DSLayout.margin,
                0,
                DSLayout.margin,
                DSSpacing.base,
              ),
              itemCount: products.length,
              separatorBuilder: (_, _) => Container(
                margin: const EdgeInsets.symmetric(vertical: DSSpacing.md),
                height: DSSizes.borderWidthDefault,
                color: colors.borderMuted,
              ),
              itemBuilder: (context, i) => FavoriteProductTile(
                product: products[i],
                onTap: () => showProduct(
                  context,
                  branchId: branchId,
                  productId: products[i].id,
                ),
                onRemove: () => _remove(context, ref, products[i]),
              ),
            );
    }

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(
              title: l10n.profileFavorites,
              onBack: context.pop,
              backLabel: l10n.back,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
