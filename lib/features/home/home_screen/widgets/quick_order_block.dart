import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/network/app_exception.dart';
import '../../../../core/utils/error_text.dart';
import '../../../../design_system/components/inputs/ds_chip_tabs.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/buy_again.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/state/active_branch_state.dart';
import '../../../../domain/state/buy_again_state.dart';
import '../../../../domain/state/cart_state.dart';
import '../../../../domain/state/favorites_state.dart';
import '../../../../domain/state/menu_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cart/cart_sheet/cart_sheet.dart';
import '../../../cart/replace_cart_dialog/replace_cart_dialog.dart';
import '../../../menu/product_sheet/product_selection_controller.dart';
import '../../../menu/product_sheet/product_sheet.dart';
import '../../../menu/widgets/product_cards_rail.dart';
import 'buy_again_card.dart';

enum _Rail { buyAgain, favorites }

/// Home's two shortcuts to the cart, each a rail under its tab: what the
/// user ordered before and the user's favourite products. A tab with
/// nothing in it is not shown; with neither, the block is not shown.
///
/// A tap on a card puts one piece in the cart and opens the cart:
/// - something to buy again goes in as it was ordered, at the branch it was
///   ordered from, which becomes the active one. A cart of another branch
///   is replaced, after the user agrees;
/// - a favourite goes into the active branch's cart with the choices it
///   starts with.
///
/// A card that cannot be ordered is greyed and takes no tap: something
/// its branch cannot make now, a favourite the active branch has stopped
/// or does not sell.
class QuickOrderBlock extends ConsumerStatefulWidget {
  const QuickOrderBlock({super.key});

  @override
  ConsumerState<QuickOrderBlock> createState() => _QuickOrderBlockState();
}

class _QuickOrderBlockState extends ConsumerState<QuickOrderBlock> {
  /// The tab the user chose; the first one shown until then, and whenever
  /// the chosen one has nothing left.
  _Rail? _picked;

  /// Asks before a cart of another branch is lost, makes [add], and opens
  /// the cart. A refused add is said in a snack bar: the card has no place
  /// for it.
  Future<void> _addAndOpenCart({
    required String branchId,
    required Future<void> Function() add,
  }) async {
    if (!await confirmReplaceCart(context, ref, branchId: branchId)) return;
    try {
      await add();
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorText(context, error))));
      return;
    }
    if (mounted) await showCart(context);
  }

  Future<void> _buyAgain(BuyAgainItem item) async {
    final cart = ref.read(cartProvider.notifier);
    if (!item.isAvailable || cart.isChanging) return;
    await _addAndOpenCart(
      branchId: item.branchId,
      add: () async {
        try {
          await cart.addAgain(item);
        } on AppException {
          // The list may be out of date: the item gone or stopped since.
          ref.invalidate(buyAgainProvider);
          rethrow;
        }
      },
    );
  }

  Future<void> _orderFavorite(String branchId, Product product) async {
    final cart = ref.read(cartProvider.notifier);
    if (!product.isAvailable || cart.isChanging) return;

    final target = (product: product, editing: null);
    // Nothing to start from (a required choice without a default): the
    // user chooses in the product's sheet.
    if (!ref.read(productSelectionProvider(target)).isComplete) {
      return showProduct(context, branchId: branchId, productId: product.id);
    }
    final choice = ref.read(productSelectionProvider(target).notifier).choice;
    await _addAndOpenCart(
      branchId: branchId,
      add: () => cart.add(branchId: branchId, choice: choice),
    );
  }

  /// The favourites as the active branch [branchId] sells them, then the
  /// ones it does not sell, marked as not to be ordered. Empty until the
  /// branch's menu is there.
  List<Product> _favorites(String? branchId) {
    final ids = ref.watch(favoritesProvider).value;
    if (ids == null || ids.isEmpty || branchId == null) return const [];
    final offered = ref.watch(menuProvider(branchId)).value?.products;
    if (offered == null) return const [];

    final atBranch = [
      for (final product in offered)
        if (ids.contains(product.id)) product,
    ];
    final atBranchIds = {for (final product in atBranch) product.id};
    return [
      ...atBranch,
      for (final product
          in ref.watch(favoriteProductsProvider).value ?? const <Product>[])
        if (ids.contains(product.id) && !atBranchIds.contains(product.id))
          product.copyWith(isAvailable: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final branchId = ref.watch(activeBranchProvider).value?.id;
    final again = ref.watch(buyAgainProvider).value ?? const <BuyAgainItem>[];
    final favorites = _favorites(branchId);

    final rails = [
      if (again.isNotEmpty) _Rail.buyAgain,
      if (favorites.isNotEmpty) _Rail.favorites,
    ];
    if (rails.isEmpty) return const SizedBox.shrink();
    final shown = rails.contains(_picked) ? _picked! : rails.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: DSSpacing.base),
          child: DSChipTabs<_Rail>(
            size: DSChipTabsSize.small,
            padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
            options: [
              for (final rail in rails)
                switch (rail) {
                  _Rail.buyAgain => DSChipTab(
                    value: rail,
                    label: l10n.buyAgain,
                    icon: PhosphorIcons.arrowCounterClockwise(),
                  ),
                  _Rail.favorites => DSChipTab(
                    value: rail,
                    label: l10n.favorites,
                    icon: PhosphorIcons.heart(),
                  ),
                },
            ],
            value: shown,
            onChanged: (rail) => setState(() => _picked = rail),
          ),
        ),
        switch (shown) {
          _Rail.buyAgain => _BuyAgainRail(items: again, onTap: _buyAgain),
          _Rail.favorites => ProductCardsRail(
            products: favorites,
            // A favourite is only there with a branch.
            onTap: (product) => _orderFavorite(branchId!, product),
          ),
        },
        const SizedBox(height: DSSpacing.lg),
      ],
    );
  }
}

/// The buy-again cards in a row that scrolls sideways, as the product
/// cards' rail does.
class _BuyAgainRail extends StatelessWidget {
  const _BuyAgainRail({required this.items, required this.onTap});

  final List<BuyAgainItem> items;
  final ValueChanged<BuyAgainItem> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: BuyAgainCard.heightFor(
        DSSizes.productRailCardWidth,
        MediaQuery.textScalerOf(context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
        itemBuilder: (_, i) => SizedBox(
          width: DSSizes.productRailCardWidth,
          child: BuyAgainCard(item: items[i], onTap: () => onTap(items[i])),
        ),
      ),
    );
  }
}
